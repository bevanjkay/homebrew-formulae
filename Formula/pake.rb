class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.4.tgz"
  sha256 "ef86b935344d9feab2badff6726fbe0ee072d63d86717b51bdeaf59deed79e77"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "28781adde9c8a22eb98711715b19ff8636bf706ed9e37822880089d0ccf96482"
    sha256 cellar: :any, arm64_sequoia: "d1b49954a45f824bf7693ceeb33aebb0a962ad57a43e257474b61e161038cbe1"
    sha256 cellar: :any, arm64_sonoma:  "0bca4c96684e93ab2e2f6c78fcfcbd9562929f9bbf172c34f1a5b9d4c57f656d"
  end

  depends_on :macos
  depends_on "node"
  depends_on "pnpm"
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
