class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.1.1.tgz"
  sha256 "ebeea895c247188a0817696818d1c0641c8a7440b84b4c7934504ffd9c6c4b56"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "219ae0e80a3496eda8f278b2827dd40abe9787aa156ba86ac25076aaeed929dd"
    sha256 cellar: :any, arm64_sonoma:  "167daf501311ece84c83010e2a5dc5e48117449b5b6370c8ad1a2c071659c32a"
    sha256 cellar: :any, ventura:       "616aea6f5f7b8eb898640a5f608e4e4ce8e12f891a152855b6846b385156144f"
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
