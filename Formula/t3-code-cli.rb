class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.42.tgz"
  sha256 "d923ecad696895bbeb19c80b983a6d791fe0366545b3556797ce278cf596fd70"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_tahoe:   "dd535383c7c540be94730993fbe5e6d703304743f66018fe3c7f68fa69bb49be"
    sha256                               arm64_sequoia: "6fb8c106fe998df64a756c5b28424d903b6b77231621a7fcb0bc59e2b870ee08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a312cbf88dd2850571eea5f8a171d33d1f43c9feb93a78b79ab532cd18da483d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc61d705210c1227a1040082d1b006df62e3bb0ed87c56d549fbea52e1cb148"
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
