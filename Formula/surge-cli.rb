class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.55.0.tgz"
  sha256 "d305beebedf1bbf1bf996978a79979e1a9c680c4aa1dac43473142d53abcc5ab"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d78d602e78b028a08ecdbf8f395a7c35f29d208cdae87672bd3c6480aca6c7d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3c412dae3705b38872d11e68779555288e86a061824b54fb1404a0fd187e66a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "440e69d15519941d2b4cde5fcce0e0fee76ca78683d00e80ce913b9be6f1c912"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "67ebbab43b58794efae465c85df3067215fb66d149400a00e0e1cfa043bd2b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2fb7bdac717def678dc77813870c3e33c4043bf40b289986b5edc324e92a1ebd"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami", 1)
  end
end
