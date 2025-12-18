class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.6.4.tgz"
  sha256 "65bf4f4386f216ed7648ad74c7a4d4a6360ec5815d89fbc0ac9b856c3ab2b12d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "63fcd0f90d1acf4f2ed032a8d5ba8c96d838e14e995ada85fa82f0f195061fe4"
    sha256 cellar: :any, arm64_sequoia: "8937b244b9701387182ac0598fc60a90d3e7e1cf9bfe8ccd910549cafb3d2e48"
    sha256 cellar: :any, arm64_sonoma:  "907fd8ce65622a6fca6e7ec4bf008de23467b5fffdfae71604fda241d2048ebe"
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
