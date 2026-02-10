class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.0.0.tgz"
  sha256 "3552cebd1463f428d49e1da78cc5049486ae5244528bc281252a8fe7a9b02a4a"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ff30604a05d80a719d1de7caccc522bd5dec50139be4905287f4ab7ead041b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40911db99a43efe97edb668bfdd62ffe0aeabe0ab1e45a9f1b4b6299a9b1386f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d75cbc77463641414304cd2181b0c009a58cd4c8b89a2a8ab3e18ed26517041a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f43beb27de905d93f969e9098d113e7cb4f33220cd90af3230814305a8e7f053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db6975e58c7528e1a4418b2c742e387602aa9d3e991cb679e27d50e8f325776"
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
