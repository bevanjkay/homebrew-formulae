class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.44.1.tgz"
  sha256 "931b32dae23d618f5dafcdb4bfca10d42ac021bc4f2d07323589528cef7c824a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f180745870d7052602a46fd458223a927c5909a1c697e8ed9d1e9ff08ed29db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e626dc807205f6ce3d35f29cacf6d7373f2d0591243df1b7c1fcca4e189ee028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49e5e13ec1348b267124ebc3b9cb1ae101431217bce01dd42178ecbe870c052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d448883a1c8b75da207a726bafdb52f19d8bbc2a6a573af7731fec1821f59930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "901b78e0d667cb9f51446667633975399ca69b9be5b5958fc08917d18d8320f4"
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
