class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.7.tgz"
  sha256 "7cc46d2314ff8560128335b99155c0ed4e7bb504213b091042ea68eee3b26224"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "2fc7c672c2b1576e1d69f1526192d2cc4137c739fe97dca5b2ac180899502a15"
    sha256 cellar: :any, arm64_sonoma:  "20c283275d3ac4c3f0331456d586250ef7c4311333284741b6c454a5da2ef295"
    sha256 cellar: :any, ventura:       "5987f371bae4dfc86d64459be719f863f4534623df09d7195f9b8f6fa9b62a74"
  end

  depends_on :macos
  depends_on "node"
  depends_on "rust"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    (node_modules/"@tauri-apps/cli-linux-x64-musl/cli.linux-x64-musl.node").unlink if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pake --version")
  end
end
