class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.0.0.tgz"
  sha256 "3552cebd1463f428d49e1da78cc5049486ae5244528bc281252a8fe7a9b02a4a"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4b4aee2453c6ed172b4c939939ae1c650aec505fdb3361c54ec5e0759d7dbef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a535737163f9f1b485ccaf16eab9aaf1549d2627cf916b8a32af2a9f83a83fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf90064d57bc9be3811fbfc4e4da08bea6644718105fadb5c09fe29b1d2b908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb63ab2c0e0844eceb8b57c9f27ee0b666c3d30b71ad8d8d2494091a081a70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c49dc09be5a16b1616e5bd190926a954d83aca0404230903f153457fc625c1"
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
