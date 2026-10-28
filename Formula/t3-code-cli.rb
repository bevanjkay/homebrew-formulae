class T3CodeCli < Formula
  desc "CLI tool for T3 Code"
  homepage "https://t3.codes/"
  url "https://registry.npmjs.org/t3/-/t3-0.1.3.tgz"
  sha256 "78c3b0121c076398dfe4a2c62cee245a5f28cc8b0fc76551cdd40b7aaa8bcf0f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_golden_gate: "6bec5a0fffc9fee05590cc99440a8adad591a917b45cc451b8747ea7ecea4a84"
    sha256                               arm64_tahoe:       "a23c5beaf09ad05248a99ba9ed4506c3ee9576785f07185876d929689705a209"
    sha256                               arm64_sequoia:     "c93ad4784a3615d9ab8745f6d336a136e1fbd93f250d0b92d679bac08f3152be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e22e64bca28500eca554e8d0b4cf09a58b5fbf3817c5ef6f444cc268eac87ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9b64b2ea7499312c75d6632d87b57d87b5a09902fbb6af467f3ab49cf0da5712"
  end

  depends_on "ripgrep"

  # Since 0.1.1 the npm package is only a launcher that downloads the
  # self-contained executable from the GitHub release at runtime. The npm
  # tarball stays as the stable URL so `brew bump` can still update this
  # formula: it cannot rewrite per-platform URLs in on_* blocks, but it does
  # update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.3/t3-0.1.3-darwin-arm64.tar.gz"
    sha256 "227f7d79e0b8aef050a2430e42d95103266ef8a7f722febfe9a28cb2d266b477"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.3/t3-0.1.3-linux-arm64.tar.gz"
    sha256 "56df87ccb37d46a0f65374b387998a08aa73f123fd8c00c1139c8b4c7bd439d5"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://github.com/pingdotgg/t3code/releases/download/v0.1.3/t3-0.1.3-linux-x64.tar.gz"
    sha256 "63cd0f0547eef62bb4ece27fa779bbf9e2ba8531cc68542568ba9e78838dc684"

    livecheck do
      formula :parent
    end
  end

  def install
    # The executable loads client/, resource-monitor/ and its native
    # node_modules from its own directory, so keep the archive's layout in
    # libexec. A deeper path breaks relocation: the install name Homebrew
    # rewrites libfff_c.dylib to overruns the header padding it was linked with.
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    odie "T3 Code has no #{platform} build!" unless resources.map(&:name).include?(platform)

    resource(platform).stage libexec

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
