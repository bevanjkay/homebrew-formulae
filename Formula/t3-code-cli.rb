class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.1.tgz"
  sha256 "11e89f2aa3ba3dd510c411edf88d35bc44e7616a893db69c2b5ea22f79db9a04"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_golden_gate: "23f1b191f2d77f30712823b2fe1d37b55b0e8acde5582eeeda1a93b6836c8760"
    sha256                               arm64_tahoe:       "43fb57e923476b08012c3708a8fb323fde53f6016860da3062e7c6bf9989947b"
    sha256                               arm64_sequoia:     "b34e531a764f48d359be0fd5dd633cf0ef41c0321470e85f124fbc38f7911e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45386fefed51606854dd66f1a9f28489309449754e6e74a8f2ea1b1182b1d81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "86e942a1001088740ebf2a4f54fec5cf17969f068950e3897abb853ef26fe3d1"
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
