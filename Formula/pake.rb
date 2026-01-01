class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.4.tgz"
  sha256 "ef86b935344d9feab2badff6726fbe0ee072d63d86717b51bdeaf59deed79e77"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "3d909230b068d83b7287246285ce46fa5560ee08f66beef0539fc4de0134542e"
    sha256 cellar: :any, arm64_sequoia: "28e5b8d1beb3358bdaad9702c9b436afe7f89a007c78cec3fd14121659ff1a8f"
    sha256 cellar: :any, arm64_sonoma:  "8dac08fdd42b419876a394e7e8757e215fe94299c2bc4b48540fdc0552384bcf"
  end

  depends_on :macos
  depends_on "node"
  depends_on "pnpm"
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
