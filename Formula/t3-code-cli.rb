class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.27.tgz"
  sha256 "4b57953dbd41842b362dc7e389bfb5937adeb380db99174e61f8e27fe3cdd042"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_tahoe:   "c3b9424859c06b62603a413d99382ad967a5ea741529ef692f2ce460f3c3b916"
    sha256                               arm64_sequoia: "db670a70262cd6a5dbbe6ce9db8e51f370c3b943838b570964da477e84206a9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7b2640c2f10cf182863377495fec9f2a5926980d05f394643c1fe05633d4d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc780a7b0cb1b331bb94aba2fe0858973325cba2265a126a944e9509aafe283e"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    # t3's package.json uses pnpm-style "parent>child" overrides keys that npm
    # rejects as invalid package names during `npm pack`. Strip them; the
    # runtime dependencies are already pinned via the `dependencies` field.
    pkg = JSON.parse((buildpath/"package.json").read)
    pkg.delete("overrides")
    (buildpath/"package.json").write(JSON.pretty_generate(pkg))

    system "npm", "install", *std_npm_args

    msgpackr_extract_linux = libexec/"lib/node_modules/t3/node_modules/@msgpackr-extract/" \
                                     "msgpackr-extract-linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds = libexec/"lib/node_modules/t3/node_modules/node-pty/prebuilds"
    node_pty = libexec/"lib/node_modules/t3/node_modules/node-pty"

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

    (bin/"t3").write_env_script libexec/"bin/t3", USE_BUILTIN_RIPGREP: "1"
  end

  service do
    run [opt_bin/"t3", "--no-browser", "--host", "127.0.0.1", "--port", "4141", "--base-dir", var/"t3-code-cli"]
    keep_alive true
    working_dir var/"t3-code-cli"
    log_path var/"log/t3-code-cli.log"
    error_log_path var/"log/t3-code-cli.log"
  end

  test do
    require "json"
    require "timeout"

    package_json = JSON.parse((libexec/"lib/node_modules/t3/package.json").read)
    assert_equal version.to_s, package_json["version"]

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
