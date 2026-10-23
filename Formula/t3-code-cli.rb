class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.2.tgz"
  sha256 "cfed5ef9c7dbef4a69d5b282cd15e259820906212b5abe531eb609aa5472f697"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_golden_gate: "b99a2a77548d37cb79f62664d41b13b72be43e6a46f6f7ef00e7e5541f844e55"
    sha256                               arm64_tahoe:       "87183c3d09e3c345fd7c15a6375546de531c1ed351c09a00e3fd9a14abc78483"
    sha256                               arm64_sequoia:     "bee387e9c1c6c90529444b7b82aa2ec5b098ff2d4c46863efe29ffcdbcb5db9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "465e799c58b687904c9b9a83dcc138e71ccb2c9f2e46992e9f223117d197235a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0b7db680accf8d4485e1006cf4bd3c14ceeb6ee3d68953260ccb83b31b7f5d1c"
  end

  depends_on "ripgrep"

  # Since 0.1.1 the npm package is only a launcher that downloads the
  # self-contained executable from the GitHub release at runtime. The npm
  # tarball stays as the stable URL so `brew bump` can still update this
  # formula: it cannot rewrite per-platform URLs in on_* blocks, but it does
  # update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.2/t3-0.1.2-darwin-arm64.tar.gz"
    sha256 "993b75ff25b5a914af18fa4e2cd13f21c7786c59414ef2774d4e702684c2d1cf"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.2/t3-0.1.2-linux-arm64.tar.gz"
    sha256 "df112e1f19772b4055a28c97b032eb6d038d5d7182015f1cafd3254ad6fabd0f"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.2/t3-0.1.2-linux-x64.tar.gz"
    sha256 "7aed625cb961938df174c1a067c0f05235360940b53e882a1643126b754da16c"

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
