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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b78184cdf29ada01778766b6be11df715721a0aada7b0228282635350859c8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa00d951eb11be9adc28a7b8ed403c291d0ecf887ae00115ad40a451e0a215a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d815323de0dfcea35cf18e89661ad94f6295b9531d87888c44215bc6fb0ac0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04a6ad3a5309c6f52472a106432ea0e0a10068428debd880da7f423b548fc07"
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
