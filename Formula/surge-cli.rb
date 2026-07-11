class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.31.0.tgz"
  sha256 "2b6923495f1b4f7dc083f06c83d1bb31699e97dae728a59867283ff11b0c4756"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0e72c1bbe771cf589e1bcfbdec1b9e04d514e391eb5fb683f602c1b1d461e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c373f84587d97c58f6ebf94aa503dd4ade26612591f60915c851732a6fefe11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd0e01c48b192c076af96314016a4dcc861f8c9f06ab530e612244948317e6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf846034e518b05d3f8a1731f35e25efcd3dbcd07d9d2e751409ea268d295ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0432f9067263649f6a734f5e23278e60f0832739decdb7c7811ead6172c4bb1"
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
