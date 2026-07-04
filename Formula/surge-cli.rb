class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.28.1.tgz"
  sha256 "c1b61a2ab1d2a5035f357a9646b23e587c79f75a63ed4b343df2608e2643cd37"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59bd01da3cfd2b5c8db56a7f79fbda628197eafc717e90f83f385b88bce26c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9d64047d3ec2748320a8a4abe771bbb541669d985944e058d644f1c460a9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9b9a309b97febb8c5c6a18da34fc3f8fe860db15f39d3583d84aa2ffae3d16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16deeb290a777ba51a4fe8d52124561d1f3cd21886874fe77be4ec838894c95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d98fcb783fffb29433bfc4b09d300a3ae86827c917ee9a909d810f65479baf"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami")
  end
end
