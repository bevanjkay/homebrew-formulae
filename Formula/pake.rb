class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.3.4.tgz"
  sha256 "e0f962163f89a063492f6d58d888ae2b536fcc86f0cdf4dc540ab44fc6a8ee01"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "4997a01daa19fa96e1998988d9c97b1b117d4cbefc268e82211c3ce85580680b"
    sha256 cellar: :any, arm64_sonoma:  "2d065d45936e1a80de4b5d017b4c827c55de8b0ec7157340b97afe97c380c362"
    sha256 cellar: :any, ventura:       "4a34ebf08e5dd6d8e02f5ed84ee686cb06b8a938fffc520368192aff3aa7e8f6"
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
