class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.44.tgz"
  sha256 "90ebb457474d49cb509e08939db8bc94afab1f0fa46c1f33b470fa2370d068cf"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_golden_gate: "197ab340a2933fb4cab86c8f1b0a189c2e6d2967509219ff6ce46eb315492190"
    sha256                               arm64_tahoe:       "db3152ea4cf3f3a01e97934b318c1c92fabe1771edff2f33805076b237ce5a0e"
    sha256                               arm64_sequoia:     "29f342ff007d2ac4f8a7846ffb997096d5014c7fd0f8cd5c14234fbcebf8d512"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1f15ee23657b7864b3a3fae7b275a93cf7fc806fe314c099b390e65abd679f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "be38389a1a5958f5e04082156fc3f8bd4566f4e7e4824afa215263dbcd92f49f"
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
