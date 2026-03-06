class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.1.0.tgz"
  sha256 "fe7a3b30e918dcc0c72a8ae92a1401ef36ba74029ca4b8f6574e3332905f09fe"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90ee6fb37cdf7417d8d3c207a549be5d0f523aec1c4fff1b9f9b574053fa5835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d071b0d5daf85b6a0d9148fc329fd26468ddb2dc35b5362cb5dba3f8d2a98a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6234f5af5b4626e63d8ff2f85f32c4a447e9416157633ff9548d68dd3c69138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e76f00a8d1cc1b0f8ff0aa71f939d543fab2355b21ed643ba7d88d080f8aa111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c273deba0abbae216d572229bd3f38c6169db895b25d9d2ad45ba6a0ccf5da98"
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
