class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.4.1.tgz"
  sha256 "fa51b0d4291593da074a5b634be76f7a02390fc26ca91df293d5adfe493c682b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "b141de3d06bb2fdf6507dab56ae8f1d295bcd7df3488a37052415d8a6f5078e4"
    sha256 cellar: :any, arm64_sequoia: "007b00118957e28e7ab6c41f769fd24789d7fadaf464d5a67c383843704ced72"
    sha256 cellar: :any, arm64_sonoma:  "afa7f6783be841c0fddc1441460f6b4717c87f1a7a809611cd3a0d8e6dfbcf3e"
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
