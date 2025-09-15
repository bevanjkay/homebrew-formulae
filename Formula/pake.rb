class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.3.5.tgz"
  sha256 "228254e4486a1b3e0293d48652ab1cffe3c2facb6541dd5f73784f0758c83623"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "f940e9fb429d61d642917e6dd6524ecbaaf1c0a45c6df70b66334c7f2a24bc2c"
    sha256 cellar: :any, arm64_sequoia: "a775f01ac673c6bf6d9312d10b0168489d8ae90ccc8e433e666e4bcde3c7a8f6"
    sha256 cellar: :any, arm64_sonoma:  "4f47ae86aa36dfe556a20289455ed6ecbe364ee95e092ac4f5c8e56f50597f3e"
    sha256 cellar: :any, ventura:       "3817be234a14fb57a1ae662216e4f87329d7c7d120f6c308892df62376c6afb1"
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
