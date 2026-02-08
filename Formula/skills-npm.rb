class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-0.1.0.tgz"
  sha256 "87163e835215fdb2d751eb75557700c887c004482f5ec754a79bcf008d0d687c"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156d86b9d0e792671ede6160e4561fcec3eeea4b759e5a91bda51f5620ac76ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a1a8ece3c40b687b98e920e22afbdf320b225f41246765edda49555aee79c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c9f5b736e4e973fe85b6d2c8b5990a1e5ad455c2602f4ff89f1fae11c5286e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f924ab8f606316f2d92bbc98e9277c237a876906dfd29da9f689b27704ff2721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dffa724cee16cb401e3d56f36eef50a73160f74f3bdee4f6d1c611e3665d0e41"
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
