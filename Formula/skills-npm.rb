class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.2.0.tgz"
  sha256 "4fd42336219a215dc3103bc36778d92ba00929b46387a949deda10f86957dbfb"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d244849046a112cdaecc1501bf77e8e7234d6a44578e6623224ab14e09aefcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1eb97c9f9be54e881155df8e40bb04399b9e8f8b815f12d37cd5bb0e5659f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2904c9f508af4e21b47f97133cc53c5a67004d37a184c6e56b0be6e99d8b9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4d5235a7ceff17a71023f6f1037b9625c3fa8db546482b3fe224ddb6077647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0653ad48253de6341023d04096b7acef1813baf81b9e30f329326392fcc3db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["NO_COLOR"] = "1"
    assert_match version.to_s, shell_output("#{bin}/skills-npm --version")
    assert_match "Scanned 0 packages, no skills found", shell_output(bin/"skills-npm")
  end
end
