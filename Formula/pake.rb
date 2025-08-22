class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.15.tgz"
  sha256 "f95f9d01566fb550d6127ea25a48c73787ae6759d114972fb6099cad5685131a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "c2b108f75411d15af0c40e9003f73e9bc7a390364b4e723b6c08152006f9e555"
    sha256 cellar: :any, arm64_sonoma:  "2d30f93160c32a99c6ab5c418df213af246eecf6a9007af780fb97f2a884ca14"
    sha256 cellar: :any, ventura:       "25114b601e5d0f0b88fdd1b304f1cd1e39f813796163b2f6942dc597684786c0"
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
