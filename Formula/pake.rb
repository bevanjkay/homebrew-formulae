class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.6.3.tgz"
  sha256 "8c48d1d35e51e2ec762042b4c219b3a07a70923d5d06284fac23d783df52bf88"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "a103828a5e0fa91a68d6aa86df429c6025ccf9fa106db7f76a854dac55b00d7d"
    sha256 cellar: :any, arm64_sequoia: "9e66b919b991dad3bebfcecb112f880d204c80b07d4989e9df896ddb62e96041"
    sha256 cellar: :any, arm64_sonoma:  "bd89cebca9a863e003beee7d78251fb2b0f248ac6d16d50aad31e244fb3ad027"
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
