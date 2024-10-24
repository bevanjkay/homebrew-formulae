class Sendosc < Formula
  desc "Simple NodeJS script for sending OSC via TCP or UDP"
  homepage "https://github.com/jwetzell/osc-js/tree/main/apps/sendosc"
  url "https://registry.npmjs.org/sendosc/-/sendosc-1.0.1.tgz"
  sha256 "5fb846a19c7881366969d8b91ffe8ed26d5062e9294a391dd96a245b8965f158"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e6ecbb909af7ddaeb321ded7d0a362ae873f5d15f1dd589c53e090a4d3b907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d8df66ef23e3ffe1fc3fd11a6c1a72fa7adf3b7186d614162b0d91917a3c3e3"
    sha256 cellar: :any_skip_relocation, ventura:       "80fd3c1f8e9a1238e807b9719884f836d10f683418ea32b6ef95a489e07e45b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363ffc8143bc8dd4295d27717935e2775b20c042b4b013a4a21594739e02fe16"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendosc --version")
    assert_match "error: required option '--host <host>' not specified", shell_output("#{bin}/sendosc 2>&1", 1)
  end
end
