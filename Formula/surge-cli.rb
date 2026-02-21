class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.27.3.tgz"
  sha256 "71430d04a980eb61a1c866256f5a2c2a40c2c44d43efef4c08c5b0e5e76327c4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab782825252f1195fbd17c608c7ba9f6ff4de2bfab35718056412230a3a2f2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86b11f71cc0983c2b91f5a91a32f818b4c17676127d2c17e3faa498d09e8d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90cf73a06838a1cd4dca79a34abd8f086f7f2f72b9d16dbf84a83a6dad026e4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef4b068b95e8dfe4b6901d068453f7eb536cc8e8492c05f5dc27bc56579c5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ddae88c97341cef39e7011ad7c65381ca5c949a65a6ad3231a2cedc1fe7266"
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
