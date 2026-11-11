class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.9.tgz"
  sha256 "d660f1bea9e9b93ba0db5ee72f19b8790fa4651aa59d0d506c4ac8fc83145e1b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256               arm64_golden_gate: "2c4e55125812343ff1ad156f08540ddeb11d1379efacd4da93c37bcdbf238cea"
    sha256               arm64_tahoe:       "d7b4f2563ee2cde0e82371ad7b893071ee2445ebaf78c90ddbdbe80640cb44aa"
    sha256               arm64_sequoia:     "211aef79e3b9be261858297dbff6e39f9fe6562da7b5b3a9a940208064136cd6"
    sha256 cellar: :any, arm64_linux:       "aac229ad176da7c53ff58e6fc0235a7e0d96d9439b7c6890d4ea7ea3855d1042"
    sha256 cellar: :any, x86_64_linux:      "840fd509a2a9dc2abf8383844ccf5ca7b7fed1e313471c4e3e1dc5565509d100"
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
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.9/t3-0.1.9-darwin-arm64.tar.gz"
    sha256 "7d2eb8c0687b70ca03a9d35498381852d3792983589e82d1fb1831c08f0b2301"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.9/t3-0.1.9-linux-arm64.tar.gz"
    sha256 "52023bc5728a4dee4de361ad6fef7c236f1efb2742ff25e29d5c55e2fb662eea"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.9/t3-0.1.9-linux-x64.tar.gz"
    sha256 "0141025335da334759cecd8db3483e09772f3600ca03674698524e7d94291362"

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
