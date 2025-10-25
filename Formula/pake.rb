class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.4.3.tgz"
  sha256 "14c8f5545a4c754f9c55bc69896bee1c4f5dbb95883cfff6f6ce628a7de3cb52"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "212b6e03c54b4c47819bf366469c172317d8aa26258ef44447bb5449b50028e7"
    sha256 cellar: :any, arm64_sequoia: "c90134cb31810643aa0e18ade2a4d1597a23614054d668b092eb817b4efa5cb1"
    sha256 cellar: :any, arm64_sonoma:  "bb88088af1756ffde0881118586db8cb0842508049d06c75fd7d51859bd0db35"
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
