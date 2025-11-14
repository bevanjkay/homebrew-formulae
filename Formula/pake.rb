class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.5.2.tgz"
  sha256 "1912debc98b1a488b26590c42b245defa2e7d1ae9cfd64aab645ac1146586777"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "bff934543d94c2a5a2036076ab43ec874f9f9db8c21f820818d5ebd5c9c8c636"
    sha256 cellar: :any, arm64_sequoia: "6b7617051e47e7a946a3efc8021a02e3a50596ed83adfb983125f103a458e5af"
    sha256 cellar: :any, arm64_sonoma:  "4ea9b47c19420b1a0a80814515ad28a780c99118e72530514177e7b4ce205b2e"
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
