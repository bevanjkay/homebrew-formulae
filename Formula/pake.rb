class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.3.6.tgz"
  sha256 "ab7b52c7458df88a00c1d9c2daececb5f103433708c808d12af946a7dd76e06e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "a775f01ac673c6bf6d9312d10b0168489d8ae90ccc8e433e666e4bcde3c7a8f6"
    sha256 cellar: :any, arm64_sonoma:  "4f47ae86aa36dfe556a20289455ed6ecbe364ee95e092ac4f5c8e56f50597f3e"
    sha256 cellar: :any, ventura:       "3817be234a14fb57a1ae662216e4f87329d7c7d120f6c308892df62376c6afb1"
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
