class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.33.0.tgz"
  sha256 "85ee80ac422606cb9dbaf5540589bf9222d87f5b5ad1b1383b659b16fb6db028"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d920e84fa1acf9f63c34e1da2336892aa29390daa18826ccf55bb4f130375c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21aaa7ac12f75a4d825d1d32a8c9dbdc5a6b22b959cbb33a36af77b3ead6f334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3f5a8578f54d0ba0ebe455a737fe1d10f7561bb2c1676887446ffe8a085352a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96f2b62bbaec27e0b910620933cc823f65994b38efa952ea541d470ff370575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974748c7e91f070aa6dba266a6c299327821737e0bb4b1f94535b074a9050705"
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
