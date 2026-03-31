class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.14.tgz"
  sha256 "e00c6eda435791e8490199bb6304a80891a29abf437cd54cad3753ec1848f74e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any,                 arm64_tahoe:   "a398d0614638889956a40f5d456fd43d28fd6f71d00e1adaef11275ef99390e0"
    sha256 cellar: :any,                 arm64_sequoia: "fd45c1abe8b6f8e9f7e53f38a1c34349a30b85ae6b185fd1a8d6a18ad015c1a5"
    sha256 cellar: :any,                 arm64_sonoma:  "021c652dd538803514f130db33ccfc547ac221ab540cfcd8708b6af75660dbde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666b8a17aab4e8a6cb97b80580d944aa00d3fdc3336fc54f630fcbdf2f44995b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f25dff2fa3e5b937bf1965c4ea6f03d5b56db71a4a866b99fe1083c093a6d0f"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args

    claude_vendor = libexec/"lib/node_modules/t3/node_modules/@anthropic-ai/claude-agent-sdk/vendor"
    msgpackr_extract_linux = libexec/"lib/node_modules/t3/node_modules/@msgpackr-extract/" \
                                     "msgpackr-extract-linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds = libexec/"lib/node_modules/t3/node_modules/node-pty/prebuilds"
    node_pty = libexec/"lib/node_modules/t3/node_modules/node-pty"

    rm_r claude_vendor/"ripgrep"
    rm_r claude_vendor/"audio-capture"

    if OS.mac?
      if Hardware::CPU.arm?
        rm_r node_pty_prebuilds/"darwin-x64"
      else
        rm_r node_pty_prebuilds/"darwin-arm64"
      end
    elsif OS.linux?
      rm_r msgpackr_extract_linux if msgpackr_extract_linux.exist?
      system "npm", "rebuild", "--prefix", node_pty, "--build-from-source"
      rm_r node_pty_prebuilds if node_pty_prebuilds.exist?
    end

    generate_completions_from_executable(libexec/"bin/t3", "--completions")

    rm(bin/"t3") if (bin/"t3").exist?
    (bin/"t3").write_env_script libexec/"bin/t3", USE_BUILTIN_RIPGREP: "1"
  end

  def post_install
    mkdir_p var/"t3-code-cli"
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
