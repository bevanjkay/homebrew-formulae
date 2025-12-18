class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.6.4.tgz"
  sha256 "65bf4f4386f216ed7648ad74c7a4d4a6360ec5815d89fbc0ac9b856c3ab2b12d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "686ffadb1c33d4c2e0d91a60d780be9f18657c3f5635449c0bff22cc69279925"
    sha256 cellar: :any, arm64_sequoia: "4d69003bc3f9d3f5a32e004ee436c97413f68b4119e1b229f820c86d64e3b48e"
    sha256 cellar: :any, arm64_sonoma:  "795c60e623380d2f0c82e61cc1a09649db67e691e3db83fcfe63eb8a313b7971"
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
