class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.7.tgz"
  sha256 "47d67b343b6c0c087ad8579b572a422d0649bae6ed1941c757c1c309eede61e0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256               arm64_golden_gate: "e75adbf22bd68a0a2e21a7d00664b13c379a20cfd82730bfeff203201dbb6caa"
    sha256               arm64_tahoe:       "85c76eae2047b5a7cd2b80dc36622d35a288a7ccef9c54e4bf0cb1079df6f77c"
    sha256               arm64_sequoia:     "410e309bc8831845c575136885cfe12eb2535a0a1cedc60949feeecbef070b96"
    sha256 cellar: :any, arm64_linux:       "aaea316ff3739c600ddff4ef1d81006fe6300d143f382676335125c7e132e673"
    sha256 cellar: :any, x86_64_linux:      "52f909908ac7cd28af6688624e9d3efd4988e36f416b35f76af19d359f25d6a9"
  end

  depends_on "ripgrep"

  # Since 0.1.1 the npm package is only a launcher that downloads the
  # self-contained executable from the GitHub release at runtime. The npm
  # tarball stays as the stable URL so `brew bump` can still update this
  # formula: it cannot rewrite per-platform URLs in on_* blocks, but it does
  # update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.7/t3-0.1.7-darwin-arm64.tar.gz"
    sha256 "fecfb296ed142942d0cb2dee1c53a6faca54a4012a312a470d4dc6c3215d1ab3"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.7/t3-0.1.7-linux-arm64.tar.gz"
    sha256 "5a528e23af394cc6f359036d3cb8441fda14129d477630fc6c53e4f4a1025bc8"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.7/t3-0.1.7-linux-x64.tar.gz"
    sha256 "c089892bf7922e2e73c6f44a5d1ea125c99f70e378c18361cbbed2fba1920e6c"

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
