class LiveServer < Formula
  desc "Simple development http server with live reload capability"
  homepage "https://tapiov.net/live-server/"
  url "https://registry.npmjs.org/live-server/-/live-server-1.2.2.tgz"
  sha256 "0b2416905687b27ecf49b994485adce24080b0412f07f8c7b382b3723dfa40bc"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_sequoia: "0c9adfdbf3e10a3c332f1974ef4f43f6050dc86512352b002b05205be40aaa71"
    sha256                               arm64_sonoma:  "4cad6b3ac0e5e919f7f1c46b247642f28d45700c5cc27f78dcc17bcc725656e1"
    sha256                               ventura:       "e64b32386f455d8e62180e7fe1071a45a0e1403e786f367e2163dfd284620034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3ccf28749c6a9761ff40943e1ddcd57751cf0a6fbcd21f71b772d26c78d89c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match shell_output("#{bin}/live-server --version").strip, "live-server #{version}"

    content = "<h1>Hello world!</h1>"
    (testpath/"index.html").write(content)

    port = free_port

    pid = fork do
      exec bin/"live-server", testpath, "--port=#{port}", "--no-browser"
    end
    sleep 3
    output = shell_output("curl http://localhost:#{port}")
    assert_match content, output
  ensure
    Process.kill("HUP", pid)
  end
end
