class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.6.tgz"
  sha256 "52f6be68cf9917ddf3f433c03870381a6a58ba4f85aafe972fc7562345a1585c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256               arm64_golden_gate: "afa063c086b3dcd969a4ac4c8b67e3c7684d6b1454bd5704d78a59f17d22e8bc"
    sha256               arm64_tahoe:       "aa322fed128a8e353deb5a83935dfc08c53eb62bec1ee4106b2a308df723f3a1"
    sha256               arm64_sequoia:     "f95d38504908cba816ff1b2aa20560a23170517b1dff83325812abd38f05e546"
    sha256 cellar: :any, arm64_linux:       "d4e2a7c1530dce2f9fb8e8592319b5736de4b3cd64ae034f260030fd8cc05800"
    sha256 cellar: :any, x86_64_linux:      "e7b38833a7b9b540611631c029da6578274cb7317a35de3b7f82d5d335b6823a"
  end

  depends_on "ripgrep"

  # Since 0.1.1 the npm package is only a launcher that downloads the
  # self-contained executable from the GitHub release at runtime. The npm
  # tarball stays as the stable URL so `brew bump` can still update this
  # formula: it cannot rewrite per-platform URLs in on_* blocks, but it does
  # update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.6/t3-0.1.6-darwin-arm64.tar.gz"
    sha256 "50c5dfd3e83787c182299a37db3553968346904e7dc7936b2a01061dbfcf90eb"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.6/t3-0.1.6-linux-arm64.tar.gz"
    sha256 "b708f059200776f50623a766854841e40eda0bb67614211cf8b6909295ce20da"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.6/t3-0.1.6-linux-x64.tar.gz"
    sha256 "7cf31da90dee41f524dd5b679ebb6d404637ca5d9dc6fd8bc019511d57bb77e6"

    livecheck do
      formula :parent
    end
  end

  def install
    # The executable loads client/, resource-monitor/ and its native
    # node_modules from its own directory, so keep the archive's layout in
    # libexec. A deeper path breaks relocation: the install name Homebrew
    # rewrites libfff_c.dylib to overruns the header padding it was linked with.
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    odie "T3 Code has no #{platform} build!" unless resources.map(&:name).include?(platform)

    resource(platform).stage libexec

    # The musl builds need musl's libc.so, which a glibc system does not have
    # and `brew linkage` rejects; the glibc build beside each one is what loads.
    libexec.glob("node_modules/**/*musl*").each { |path| rm_r path if path.exist? } if OS.linux?

    generate_completions_from_executable(libexec/"t3", "--completions")

    (bin/"t3").write_env_script libexec/"t3", USE_BUILTIN_RIPGREP: "1"
  end

  service do
    run [opt_bin/"t3", "--no-browser", "--host", "127.0.0.1", "--port", "4141", "--base-dir", var/"t3-code-cli"]
    keep_alive true
    working_dir var/"t3-code-cli"
    log_path var/"log/t3-code-cli.log"
    error_log_path var/"log/t3-code-cli.log"
  end

  test do
    require "timeout"

    assert_match "t3 v#{version}", shell_output("#{bin}/t3 --version")

    port = free_port
    read, write = IO.pipe
    pid = fork do
      read.close
      exec bin/"t3", "--no-browser", "--host", "127.0.0.1", "--port", port.to_s, out: write, err: write
    end

    write.close

    begin
      startup_output = +""
      Timeout.timeout(10) do
        until startup_output.include?("Listening on http://") && startup_output.include?(":#{port}")
          startup_output << read.readpartial(4096)
        end
      end

      assert_match "Listening on http://", startup_output
      assert_match ":#{port}", startup_output

      output = shell_output("curl --fail --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      refute_empty output
    ensure
      read.close
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
