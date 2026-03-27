class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.14.tgz"
  sha256 "e00c6eda435791e8490199bb6304a80891a29abf437cd54cad3753ec1848f74e"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    claude_vendor = libexec/"lib/node_modules/t3/node_modules/@anthropic-ai/claude-agent-sdk/vendor"
    node_pty_prebuilds = libexec/"lib/node_modules/t3/node_modules/node-pty/prebuilds"

    if OS.mac?
      if Hardware::CPU.arm?
        rm_r claude_vendor/"audio-capture/x64-darwin"
        rm_r claude_vendor/"ripgrep/x64-darwin"
        rm_r node_pty_prebuilds/"darwin-x64"
      else
        rm_r claude_vendor/"audio-capture/arm64-darwin"
        rm_r claude_vendor/"ripgrep/arm64-darwin"
        rm_r node_pty_prebuilds/"darwin-arm64"
      end
    end

    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"t3", "--completions")
  end

  service do
    run [opt_bin/"t3", "--no-browser", "--host", "127.0.0.1", "--port", "4141", "--home-dir", var/"t3-code-cli"]
    keep_alive true
    working_dir var/"t3-code-cli"
    log_path var/"log/t3-code-cli.log"
    error_log_path var/"log/t3-code-cli.log"
  end

  test do
    require "timeout"

    assert_match version.to_s, shell_output("#{bin}/t3 --version")

    port = free_port
    read, write = IO.pipe
    pid = fork do
      read.close
      exec bin/"t3", "--no-browser", "--port", port.to_s, out: write, err: write
    end

    write.close

    begin
      sleep 5
      expected_port = "port: #{port}"
      startup_output = Timeout.timeout(5) { read.readpartial(4096) }

      assert_match "T3 Code running", startup_output
      assert_match expected_port, startup_output

      output = shell_output("curl --fail --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      refute_empty output
    ensure
      read.close
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
