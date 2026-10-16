class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-4.1.0.tgz"
  sha256 "084b08ad435d95d3f28ca10823340a32b7720e867fd27beafd894c255536960b"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aace2696362dec61db80955331a6aca9224cd054ac6f9c938b9e1c9d4ebea4c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a96200b676b88a2740eaae0e09b7e1fe3b3db0fdf25551f2b79b9448552aff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ca9ddcb463c45039062bfe9031f4965d29a9056cd18d2715be5b427ca878e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7f2ce89a683f2a3ab339d6c3d4920cb2b45c4bb8d488351f2adf02e14f24f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f07e8c00c5f8496d479546b418b1ac5fa6fd0312820fbc60783ed2d9ab80e460"
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
