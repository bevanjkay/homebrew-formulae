class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.52.0.tgz"
  sha256 "66751799bbe418eef73a1597e33769dd85d3b607a788c406544887c19b68ef7c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b11c2d8720a09fec47ed04ca93b231656d5dd21e88e06c45246ddc972fa3ff8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04d22b25b7b3166ee245ed1ae6bd4f6d4f36bf14345caf080fca05131ebbb1b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "718a181fcbf4da1f21ea36271e24b73537ab4df5a1ecb134562eff6c04e622b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e884f9e177b106bca7c8d7c1b89086c2ef6e954aa8140d006aef1ac023fad79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8ad9b6f965adf12881d3c9d6b51b934d708a951b013f7f29e4bdd26e62c187fa"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami", 1)
  end
end
