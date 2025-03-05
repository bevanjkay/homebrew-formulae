class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.1.1.tgz"
  sha256 "ebeea895c247188a0817696818d1c0641c8a7440b84b4c7934504ffd9c6c4b56"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "c4b3e0264cf9c18b333aadc0076351b0fa88515738e325e0fe1ef6ca8f558518"
    sha256 cellar: :any, arm64_sonoma:  "9581b208e2123544fe87d439bbe1bce03b189563f47de94485912ac260a3e5de"
    sha256 cellar: :any, ventura:       "5d00f8d1c9ea2be37b36b3efc5219ceeb0602f52503e2f9cd877b8fd825e6d87"
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
