class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.44.tgz"
  sha256 "90ebb457474d49cb509e08939db8bc94afab1f0fa46c1f33b470fa2370d068cf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_tahoe:   "4b414d4b2ef98ce7ad9f0513df82dafd5e5dcda92fba1056c604bb1f656d1bf8"
    sha256                               arm64_sequoia: "70209afb1846059bc49b66b57f2768fc490c219e1108f5f4f0a369201351478b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19fefbd4556809c2b1ceccbf82577131c4a2a869f7dbbbc78e99cb395c7a9c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c03eb4448dd09238d6085be6636925e5b229e195e220dbad35156ee0c95825a0"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args

    # The real CLI is the self-contained executable in the
    # @t3code/t3-<platform>-<arch> optional dependency, which npm resolves to
    # the native one. It loads client/, resource-monitor/ and its native
    # node_modules from its own directory, so hoist it to libexec and run it
    # directly rather than through the launcher: under npm's nesting the
    # install name Homebrew relocates libfff_c.dylib to overruns the header
    # padding it was linked with, and relocation fails.
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    payload = libexec/"lib/node_modules/t3/node_modules/@t3code/t3-#{platform}"
    odie "npm skipped the @t3code/t3-#{platform} optional dependency!" unless payload.exist?

    payload.children.each { |child| mv child, libexec }
    rm_r [libexec/"bin", libexec/"lib"]

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
