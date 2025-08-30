class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.17.tgz"
  sha256 "c85b4255b6b6ebe98398e5e5ed992f6e4bf5fac88d77b57efa62dbe05bf744ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "a1c1092ed0b6febb260ee0b4a1a68e68486ee81099769a8bd0cd0227ea2956c6"
    sha256 cellar: :any, arm64_sonoma:  "da57b921ee20b4098f888b8c2c0ce910a6033ec636b76179075e987b3f01e013"
    sha256 cellar: :any, ventura:       "6eebf8f8a4cf974d922b8cf6e1774cac97010d9d7d669cfc89a04156bb01bb45"
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
