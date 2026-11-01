class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.55.0.tgz"
  sha256 "d305beebedf1bbf1bf996978a79979e1a9c680c4aa1dac43473142d53abcc5ab"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e81d35177832d14eade82ec39fe7227ed90527f0b523812c58e2d15b088d4bc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11957dfecd0e4cf1d894c6349f6a40216548f10d79232634c2f97170240916e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e01451baaaa380f0b60ed2642c9f6b2e4f5d8f292fa3ea14e7f074a056f18e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "117ca871ee2c05e9d4c1433f440839922e0b698e542b32812f74f131262be244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c1dfefb78254d68aadccbce5a6ad4021c7c1bd14f5676036b90d0927ddd01a9"
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
