class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.4.2.tgz"
  sha256 "65ca96e09767fc6169592bb91da487cea101c9504b3b0a4ca7a63c75a7972d6a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "f0cd11112bf2af3fc0e6d7766e25c1dd43b5a0b1948705ca37e33c5a162e5d8d"
    sha256 cellar: :any, arm64_sequoia: "4ac4a30678a73c9ede0b527869da647b8a6f1f82d73e60acbaef34c6617950b2"
    sha256 cellar: :any, arm64_sonoma:  "ee642a1d1b6d61770b331eea35e97bb1b6fb38d17146fc46bc09e0d458a90eea"
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
