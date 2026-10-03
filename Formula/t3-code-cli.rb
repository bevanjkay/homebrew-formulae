class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.45.tgz"
  sha256 "b39b4e078370947e58c8ed9d9250105d949cf87919053347bf26b05db3da770a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_golden_gate: "3f2958ac058eedd47a0f5b0cce0807945c906b95f92a747281102ad66c20cc3a"
    sha256                               arm64_tahoe:       "121fffd73efdf9230d92268b4931acd881f23abb56730dd7809cd1077257d79f"
    sha256                               arm64_sequoia:     "78a9ec79f66a9741e979d08b09c9ea3a680702d6b68ebdf494f9487686ed2a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "70ec1ec54ef549bf6376cbca9433581db8c76bb876c37ab72e8d11890fabf7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ca28e06eb7d344ebfa2bf8d622d82bff81650d6db83c6f0478d88eb7d932c79"
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
