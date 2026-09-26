class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-3.0.0.tgz"
  sha256 "10a0e51ebb8931afabe33ff89abcf365c8258d1750f6244b3e3cb2aa3a9e8d1d"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cf01062a17a81d8716038437141b6d823fd9722c549e2500a88555eceb1d1dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0544f8f27834c419a1f3f49a7f5b3082028b548bd0530899dc8ebb933b4596a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46678d87e9819f625a41ebc4e4ed68252d425ba422b1fa32557294013fd9f7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe14e3967519337c28adc926d054741514bbf4b70cc350ae8b9cc700b39a372"
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
