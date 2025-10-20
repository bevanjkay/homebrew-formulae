class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.4.2.tgz"
  sha256 "65ca96e09767fc6169592bb91da487cea101c9504b3b0a4ca7a63c75a7972d6a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "6864cffe8068a91bcd23ab475ee433e34a9a4a1ea636fe211ef530b06a3ce6ae"
    sha256 cellar: :any, arm64_sequoia: "e5a740fec3bee662b5bfe2c31a6e0d7c30f324db13e6dfd8b3eccba22e02f5c2"
    sha256 cellar: :any, arm64_sonoma:  "2eab38a88ffa0d907898ebe0f48e13ba3f866e28a6cd9fe260a9bae552487806"
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
