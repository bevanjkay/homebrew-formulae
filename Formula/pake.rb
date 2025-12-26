class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.3.tgz"
  sha256 "78357f01da3bf924a76c54f3ac2bcedab3c9707a51dbb803905919203849fb73"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "1abcd72a830be39bdc34a2ed80567183b9d36009732c3c170f71e035e58a5544"
    sha256 cellar: :any, arm64_sequoia: "6f96a9824205010357a9ef40310cedf277619ee02cf3be24d02843e629dea162"
    sha256 cellar: :any, arm64_sonoma:  "3f369b70de76a4a1244d950187e9847a7725a2b4508a4135c9f55376903f077f"
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
