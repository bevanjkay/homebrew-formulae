class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.1.1.tgz"
  sha256 "f513de7fc861c9c905f5b23c96249880abcc3785f76e8f4359dd64b11ec33d1f"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8290cdbd95d613d2315ab8257f75b6ce9cfdf6deba70b99ff46076e9ccc5a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041e063cba2d88e1ee318db3a42f1952650deae9db2eef842492e073a5a7e447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1d4eb745a5ccaa014d4e3c3cebbcbe9e15c1896f5b24d7aa1405f8656ca5eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a604936f762b4f2777ce03cfd2d79dfab16d4e0fd647b56b5d1fc3b7b7e3a376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c75e1d694e31ccfc05bd315a90974b580139d15492da6891f3d9f0f38b2cb49"
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
