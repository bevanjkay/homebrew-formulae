class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-0.0.3.tgz"
  sha256 "475a4d86ae0cb29c3923a48bcb779cffb6120d25d81f9ceec68ccdbc14c05083"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6ec79391eac1fd3809662d55216517f211bda49bef78a4f997ec69cc8b2a871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a4c47a468b2b40f742dfe03b161aa0e5ae8c5525ea1b86c0b98a662b6193b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a402e6d1e984596417a0ec699be29116ed6edc6e933e0bdd111a451fc83183fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07c0d1d1a2a10a4f7c0d34311679ab0caaad86c4e6f46d53620b1e71eadb809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9464c8ddb1f4125cc8497163f1946d605f51316842d5620ffe742b1f3d1f80c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills-npm --version")
    assert_match "Scanned 0 packages, no skills found", shell_output(bin/"skills-npm")
  end
end
