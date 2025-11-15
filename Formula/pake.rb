class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.5.2.tgz"
  sha256 "1912debc98b1a488b26590c42b245defa2e7d1ae9cfd64aab645ac1146586777"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "4331fc9b2f142f6fd0c6bf7eabacca1657c8cbc76b4cef96aab9ed908b34ba4b"
    sha256 cellar: :any, arm64_sequoia: "c6e721864b411f031d48bdea9845e85cf6871759082db3f30b3a99fc8e2df71b"
    sha256 cellar: :any, arm64_sonoma:  "2ac0d082b0fefb587b5292273338c39738b088773da716b7a88546b898bd78e6"
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
