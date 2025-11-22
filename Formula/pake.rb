class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.5.3.tgz"
  sha256 "bcf94bd183548fb15f06513751e869f212e688f62bf97cdc0dd97cbe68750060"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "5d7a909d6351fa840325f2fe4ac33e64750e93d922ff6157b8c09cfe30158585"
    sha256 cellar: :any, arm64_sequoia: "5df2d3e6b9d23d27a7422f96b98d239bb9bdcc4de10f047fac1b472627987482"
    sha256 cellar: :any, arm64_sonoma:  "8851c67e8ac510d9e162b5c9fbb5ecd0865ca6988d7761b810961d237964b168"
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
