class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.6.1.tgz"
  sha256 "e3ab6dd8555aa8393f9658df65ec814e78b1b2749b204bfadaf9b19d08e9bde3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "767228776eb262550613a2b2a518542c31577caf93d82cb549c0a49b2ae622cf"
    sha256 cellar: :any, arm64_sequoia: "b31caed70eed224e08ee66644e1e72f7718aec3129ede465752d360df8bb25a8"
    sha256 cellar: :any, arm64_sonoma:  "a5baba0669868c024d6869d49c72e51878a777ad049262f58a386445b66ed08c"
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
