class Bible < Formula
  desc "CLI for YouVersion Suggest API"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/bible-1.2.0.tar.gz"
  sha256 "2db0a5fe8e1c6f49afb92007dae027ac885ef3f27606a53046ed4b0ff4f5a44f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^bible-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7593dd474306c235c13be65900d1e964a3972e1a0fdf4585bb1f505f04fff03e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70d185ed3df9205adcdd31ef4f8ea4252128bdddbe399e1271ac200284571b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "931410640fe7e54d7b285b41d3d4df5c30c5fe5518e1f72805dd0982afe476dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91a778c041eb5adc88e27148564227dcb7505a21332e00dbc04fc2b339d7a166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "01505c13f2c42e4c662a20811a5f388d2f2f6e9525f82035a9ffca9d759d8fe7"
  end

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build", "--workspace", "bible"
    cd("bible") { system "npm", "install", *std_npm_args }
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/bible john 3:16")
    assert_match("For this is how God loved the world", output)
  end
end
