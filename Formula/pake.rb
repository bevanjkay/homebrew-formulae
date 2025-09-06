class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.3.4.tgz"
  sha256 "e0f962163f89a063492f6d58d888ae2b536fcc86f0cdf4dc540ab44fc6a8ee01"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "c7ad278c58da58faad7ccb05f8a58cb50101e501ac71659c938792d6c5d716fe"
    sha256 cellar: :any, arm64_sonoma:  "6f2cfc10fca80ea00793540cf85994421a1c5dc12aa099ad383f06aeb88d3b10"
    sha256 cellar: :any, ventura:       "3ee6e924f38de3b6a1f9f9da19ee715c597ebb735d1109f499cf00677e36b39e"
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
