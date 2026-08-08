class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.32.tgz"
  sha256 "d12cb21b8cf31c37da6755757dbadd7eeac5f2fb66944c1e93ef99557928764c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256               arm64_tahoe:   "9be53c5bf3f4f95955cc61085776c0e69e35f4f53f1656e89e88ea90b74a665a"
    sha256               arm64_sequoia: "fe8d4ac73d648efb19bf757f723e4c84e09ecaea6ec486fec5354c7df20db198"
    sha256               arm64_sonoma:  "f128ba8a82e73f401461d0048df8f81653d7a182c38bee36807dd53dd237dbc7"
    sha256 cellar: :any, arm64_linux:   "5079f9b3fa8114e4bc24e567bbf53e8e89fcd3f178fbad9de6cae7edef23faff"
    sha256 cellar: :any, x86_64_linux:  "4b3fd70ebce5677299e50bf77c94b2b99e51d4faa4a1829c54b57579ca2dae84"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    # t3's package.json uses pnpm-style "parent>child" overrides keys that npm
    # rejects as invalid package names during `npm pack`. Strip them; the
    # runtime dependencies are already pinned via the `dependencies` field.
    pkg = JSON.parse((buildpath/"package.json").read)
    pkg.delete("overrides")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(pkg))

    system "npm", "install", *std_npm_args

    claude_agent_sdk_linux_musl = libexec/"lib/node_modules/t3/node_modules/@anthropic-ai/" \
                                          "claude-agent-sdk-linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}-musl"
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
      rm_r claude_agent_sdk_linux_musl if claude_agent_sdk_linux_musl.exist?
      rm_r msgpackr_extract_linux if msgpackr_extract_linux.exist?
      system "npm", "rebuild", "--prefix", node_pty, "--build-from-source"
      rm_r node_pty_prebuilds if node_pty_prebuilds.exist?
    end

    # 0.0.31 added prebuilt resource-monitor binaries for every platform t3
    # supports, keyed "<platform>-<arch>"; keep only the native one. t3 already
    # treats a missing binary as a recoverable error (no linux-arm64 build is
    # shipped at all), so this only drops resource monitoring where upstream
    # does not support it either.
    resource_monitor = libexec/"lib/node_modules/t3/dist/resource-monitor"
    if resource_monitor.exist?
      native = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
      resource_monitor.each_child { |target| rm_r(target) if target.basename.to_s != native }
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
