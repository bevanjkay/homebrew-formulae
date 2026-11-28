class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.13.tgz"
  sha256 "6ebfe5ba06b6a41e0811c994020b1724949ac550ce1e0f5ffa3451d0d3ba6f08"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    manifest_sha256 "1d03ab34a3116697940fcf458967164f67700f4ba46eeb96af9fd575bbdbbf9b"
    sha256               arm64_golden_gate: "b223b687820c158a4b973ac84d33b68d934d893e6ac01946e84b8d9e20082bcd"
    sha256               arm64_tahoe:       "da091fab11563c83d9b94116e594c985978a79ef412877209bd662beaa88b58c"
    sha256               arm64_sequoia:     "12566522c733adfdf118ea6b62a25b99aa52e9d2600d7bde92686a65dc7da3fd"
    sha256 cellar: :any, arm64_linux:       "d99a4e3c89e0e78df4618b827c1c48cc0913f39a4b99fdc66eadb3efeb754152"
    sha256 cellar: :any, x86_64_linux:      "7a1629923c6c73fdfc03fc35c538fa6fbbeb670ab10bc75907a4d1f223b3b7f8"
  end

  depends_on "ripgrep"

  on_linux do
    # @transcribe-cpp ships a ggml Vulkan backend for on-device dictation.
    depends_on "vulkan-loader"
  end

  # Since 0.1.1 the npm package is only a launcher that downloads the
  # self-contained executable from the GitHub release at runtime. The npm
  # tarball stays as the stable URL so `brew bump` can still update this
  # formula: it cannot rewrite per-platform URLs in on_* blocks, but it does
  # update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.13/t3-0.1.13-darwin-arm64.tar.gz"
    sha256 "d83b2e1ef9557e12f340a7299646203cdcdd5ee0af3272e6922c26410cfef396"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.13/t3-0.1.13-linux-arm64.tar.gz"
    sha256 "c553c17db07030d032808989427db5022bf04027ebcec2218c69fb1a5fa1377f"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.13/t3-0.1.13-linux-x64.tar.gz"
    sha256 "64e0f8446d3f618b157d4e5a0a6808ab3c8bf1a1b3e44eab3100e554be05e5d7"

    livecheck do
      formula :parent
    end
  end

  def install
    # The executable loads client/, resource-monitor/ and its native
    # node_modules from its own directory, so keep the archive's layout in
    # libexec. A deeper path breaks relocation: the install name Homebrew
    # rewrites libfff_c.dylib to overruns the header padding it was linked with.
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform = "#{os}-#{arch}"
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
