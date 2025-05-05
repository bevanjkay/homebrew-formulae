class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.1.1.tgz"
  sha256 "ebeea895c247188a0817696818d1c0641c8a7440b84b4c7934504ffd9c6c4b56"
  license "MIT"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "31134b94d563594b7602b8bd5db552a1a7bc4b88c735db5633e4bb440465e0c8"
    sha256 cellar: :any, arm64_sonoma:  "a3b9039b49ace34d8d796991b4c82d53bad3062222b77f5c2417f1da59ff930c"
    sha256 cellar: :any, ventura:       "be1eaa78900a0956f93d00bf762f6a98f70b3be08ca7ed38c9cf7ff44aed7d1e"
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
