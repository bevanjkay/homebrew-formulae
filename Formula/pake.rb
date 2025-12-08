class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.6.0.tgz"
  sha256 "873d2b159226ac7883f8bea324fece15b5f5fb747c21e327d51c58b2646792aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "4193beb73152669d3532a533f857a5e3e3b5078c1c6bade9601c12d05d14d6cf"
    sha256 cellar: :any, arm64_sequoia: "912370349490a306b6bd0df0544678cd110e1d875e5a45fb40a170c6be03a177"
    sha256 cellar: :any, arm64_sonoma:  "9cae581a37ab6b985e110058057e9dec51c566ff3e5402cc9f491a8fe1686ff9"
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
