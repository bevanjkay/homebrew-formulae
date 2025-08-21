class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.3.tgz"
  sha256 "9eea35b9e7f65d201fb78691f08dbe82fbffb90d9616df5f61536ba6b14e5191"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "707d593c72b8bc50ffd5e7a5bb79fcbfe048d15db49bbdd921c5337e92c235e5"
    sha256 cellar: :any, arm64_sonoma:  "6aa81ccf024c3e43bdcf8c61a4fd1f5b35b24ba1ff6b0cf71a5b10d161f73675"
    sha256 cellar: :any, ventura:       "7176961827c6a72dc1bc303a4abb414a70a3865e13c7a94db52e9971be7bd221"
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
