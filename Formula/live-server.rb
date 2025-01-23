class LiveServer < Formula
  desc "Simple development http server with live reload capability"
  homepage "https://tapiov.net/live-server/"
  url "https://registry.npmjs.org/live-server/-/live-server-1.2.2.tgz"
  sha256 "0b2416905687b27ecf49b994485adce24080b0412f07f8c7b382b3723dfa40bc"
  license "MIT"

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
