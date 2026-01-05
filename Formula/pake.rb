class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.6.tgz"
  sha256 "3f5d2712b7cf63bc6cc576e731c5cb37136ed74abb56bee2fe4cb327993a98d4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "2d3b04e978ec791b536c115578c9b3c15dec30d49d5ea156a78ea45bf63628c9"
    sha256 cellar: :any, arm64_sequoia: "9b0c6ce34cc76bbde7e40060edf4d3fe0b11df6fa6d6bab00b0db092defe5afb"
    sha256 cellar: :any, arm64_sonoma:  "84f7891e57203078f11b2b0ea85734674cadaf7bfed6e4ea0aaea404a3f92205"
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
