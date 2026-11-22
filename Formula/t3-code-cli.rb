class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.11.tgz"
  sha256 "dc50554ac5329cd01850868b91942be06ae2e7ae169644f3dea3e0db3f2291e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    manifest_sha256 "b08ad00cddab0f32c2eed4a9542cd847c0c2716a5e2ee26193fccf7d661c5f70"
    sha256               arm64_golden_gate: "fa2b9b90eb84aa2043ae98c66b8261e01a6e9d2022e6a829f140c2a12182b3ae"
    sha256               arm64_tahoe:       "526de3a9819423439071404033dfa92964955e1cc212137320185707f570de73"
    sha256               arm64_sequoia:     "4051baef464006c84a1b79ca75bcc97a0b9cd3f3dc63863496f13a481847f891"
    sha256 cellar: :any, arm64_linux:       "7d0615faa70d59e43b6340d56ea19c24467977454a591114c30d07a9ddbf57be"
    sha256 cellar: :any, x86_64_linux:      "205f60a78469307886431bc4708cf37f87daf81ce57d40ca7a1b32c2b4807411"
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
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.11/t3-0.1.11-darwin-arm64.tar.gz"
    sha256 "4bc22e16a2e48d868ad8c4b9d6c8e031be1c566ce31c28267955c2986a70e95f"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.11/t3-0.1.11-linux-arm64.tar.gz"
    sha256 "7d90a5af032fe0988a616403e0f51a6cb68eff7ed7a84bc40999cc3997dffd71"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.11/t3-0.1.11-linux-x64.tar.gz"
    sha256 "2b691c07f5bcb5adea4a863d5324aae7db21bd6d82280cec7787836dcaa013e1"

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
