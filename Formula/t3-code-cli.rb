class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.22.tgz"
  sha256 "0813f2ed14023b94d99fb51eb17dd5c59d6e3edc65ff9b3779c4e7c5854d768e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_tahoe:   "eedea52544d912477e97d3c809472f285c755a6040b0d923ac29f14726c1a13d"
    sha256                               arm64_sequoia: "ec145cdb758713df4e750b9efcb7aa568032c686a68993f7c278ce798808573e"
    sha256                               arm64_sonoma:  "0c20232b0eb18e2ab772ea4116f5dc8c33b2d0d6e8580379016c1aaaf2688cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddf70d74fa51ae2e542ced64bb509758ee367f6c3b83e152d118bf52567e8847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "380decc9a1f2c56dd4fe4beef97838d08960a34e3347f1583dc3a1fa4b12d6e2"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
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

  def post_install
    mkdir_p var/"t3-code-cli"
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
