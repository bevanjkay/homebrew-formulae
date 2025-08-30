class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.2.17.tgz"
  sha256 "c85b4255b6b6ebe98398e5e5ed992f6e4bf5fac88d77b57efa62dbe05bf744ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_sequoia: "68ab399aed454454c0f6c5aff25320a19bb8ccacab2adc42c3065e80123578b2"
    sha256 cellar: :any, arm64_sonoma:  "35404de676068147ecaa98665a8634d36c52e210cbab555e1e1508d60114dc82"
    sha256 cellar: :any, ventura:       "f7e44ec0206b69761484a366a3f5f8e69b71b1233a4ee7c546ef5635f8e0918d"
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
