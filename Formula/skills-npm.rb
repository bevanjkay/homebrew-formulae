class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-4.0.0.tgz"
  sha256 "5c6070fa6f27c937ce838d5a112367917c71ddd50d4e6548dcdd0bb3c686570d"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c966ae0daba20dc3a3a962336222a30e902dd2b04443e7e3f0e244566a0df1cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142f7d099a01606f171fe93861dd724a083cd0f0d22f3db83c851f5347f11e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c09a622be02d26731333d06e216135030378c182ef397bceeb21e4d4f9f57043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d3932e5e025af1cad48f5173846a3f99edf170740f0dd67a7900817daaaa76"
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
