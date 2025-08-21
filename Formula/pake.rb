class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.8.tgz"
  sha256 "5e7dd9c34e00de4dc8194e4ae8179191309087051e7b640223cbbc850ba0c854"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "45e327de2d7c30d848db60f22aa88213b6bf26d84df8a76007b8a73d8c399cd0"
    sha256 cellar: :any, arm64_sonoma:  "e273f1525e831a4e36099b1a7faf45c765abaa244e1171b96512cccbebe8850b"
    sha256 cellar: :any, ventura:       "55fd61710c2a4f29d318efba72fc98a2d39b47f0bab9142a5e4c6f142d2b6a12"
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
