class SkillsNpm < Formula
  desc "Install agent skills from npm"
  homepage "https://github.com/antfu/skills-npm"
  url "https://registry.npmjs.org/skills-npm/-/skills-npm-1.2.1.tgz"
  sha256 "7fe27c4b4fea45a13419db82a723454bcb86f5d9d3181ab482aa01940017a4b8"
  license "MIT"
  head "https://github.com/antfu/skills-npm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e7d9415d7e55dd2778de61560856c2ad9a7694f1f18c36a1f128f28a08d1e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da81b3022b7030d092bfe70dd04c14207b30ed2b57d4afb4dc94a8d9d5581992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b9849715ff50a3e3e622a7188d27cd90b41e92e5531d55539426e067a0c3d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4449af3c6ec08b5fc17ca791a627742b280bae8e44cc67b6009e9213e5f020f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8703acdeb5b9e23c219b34e31936f4ad09dd8a6d707f580e18207124d38bccb2"
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
