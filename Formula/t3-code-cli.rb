class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.12.tgz"
  sha256 "b38114f56fb9f8852fc6745c6829812efad0f959f860326c3826337f60548d57"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    manifest_sha256 "e6f04cc78ba417fe6b06cbe0e0cf01a0fe6e1fe2f1f1f68dc40f2bc8be41a15e"
    sha256               arm64_golden_gate: "dac3b5a3044463545bc379a8b077768ee55142b07300ff0c07202324678828bc"
    sha256               arm64_tahoe:       "4b4f72f19840a91fc579b7762e58be60eba1b79ebc2e31deca6d67e4d0d49f4f"
    sha256               arm64_sequoia:     "f5b2586e1633be57eba55316e6893da44981fbdfedda4ebc4d40118f8ec0ebcf"
    sha256 cellar: :any, arm64_linux:       "5aa589f3e3f85b4c0b0ef5b1af90b2f9ae88e812a0e8222a28e384250e8a93f2"
    sha256 cellar: :any, x86_64_linux:      "36a728d0087e774ecea23ce107ef36f7ec48f8ad3e70f69984913693e0948e35"
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
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.12/t3-0.1.12-darwin-arm64.tar.gz"
    sha256 "1b78c9754160623661c5942a7e22f5a62a64bf1f96ab397f50bbc7c6b6115ca4"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.12/t3-0.1.12-linux-arm64.tar.gz"
    sha256 "29cfbab19117aa436f1700382afb9cfe5d7ef47609cabba9356271a0bca5ad98"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.12/t3-0.1.12-linux-x64.tar.gz"
    sha256 "9ba3db46e3554fb9970fd5ede9e823c2f6d6f6763f40340bd4c8ef6b09501c54"

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
