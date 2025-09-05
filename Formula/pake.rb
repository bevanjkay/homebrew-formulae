class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.3.1.tgz"
  sha256 "60e7cc2a9f575c7674f181b5c5a71f5c7099402adc16c70f8e9d9cdb39ad22be"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "cea25361d39ce49bba93cbf4144fe8dd397649de22cd024319a70e1c832a757c"
    sha256 cellar: :any, arm64_sonoma:  "2e35f263e3e8812369dc85beb9a252b64a9d320eb145ede303dfbfaff11f9a84"
    sha256 cellar: :any, ventura:       "ebb087b14bb18481b4002e06595b5cb807b1199b980acbb4b549e2762a45cc11"
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
