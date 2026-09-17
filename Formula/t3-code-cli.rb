class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.0.42.tgz"
  sha256 "d923ecad696895bbeb19c80b983a6d791fe0366545b3556797ce278cf596fd70"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256               arm64_tahoe:   "fe84ee18e2b5374fc6dc54d826356a66f23d1bde9b056d340812a20eeed6676c"
    sha256               arm64_sequoia: "3a3bdb280ddd80e333d15c16ea4b46dcaf763fe01e83bb9c7c8c847e8104b5d0"
    sha256               arm64_sonoma:  "c4bd93970e5403ee31983e41b2b64ae792fff3494b9e8c684f16636ba2dbcf82"
    sha256 cellar: :any, arm64_linux:   "e3b65f017262431a5c536e0b1fa2f7af55032a8a5b70768e4ea0c232cc12cf5d"
    sha256 cellar: :any, x86_64_linux:  "5c28dcd8b38b55c1b6b6aedbe8389bacfddd17880cc3a916a266d840efda1d5b"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    # 0.0.42 turned t3 into a launcher: the real CLI is a self-contained
    # executable in the @t3code/t3-<platform>-<arch> optional dependency, which
    # npm resolves to the native one and which ships only native artefacts.
    system "npm", "install", *std_npm_args

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
