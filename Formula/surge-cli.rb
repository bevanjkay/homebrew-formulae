class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.44.5.tgz"
  sha256 "3445a5d6f00a61b32390e73694198c1c46c95c0b41d1f7d05434bc3248671edf"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f26c471d149e0e06a318a8dd8220044e85faf5f07270fac51c5df9b5c14f40ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b913866fb5eb9dab2e35a3f31d922b81ee34990aec43ec927d07249148627cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc5e65e757f5927fc137a75a6358ff2d8f51a42b07f148fa4b2f60ddcf13aebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "93507b39eddfc95f37735bdcb5b080ec4d246de2b0146f85435f5f13d609ab88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2dbc9f93e9cd96e69d976e9581a9592988a4ee627cb3765d54ed8c37ec682de3"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami")
  end
end
