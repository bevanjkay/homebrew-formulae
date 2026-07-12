class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.31.0.tgz"
  sha256 "2b6923495f1b4f7dc083f06c83d1bb31699e97dae728a59867283ff11b0c4756"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5363742771009b4ef56e6858a2d4b87c3038576aeb5b87020e4bd6586ee6bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f17607baf58db3e59bb3a80c3b35bf8599dce4e90dd8ad2d7a0dcf616d09c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef54313ecd698c9e1bd148f0d7ec1cb547a302e620d301e33ff3b2d73e0f3409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236a70c83ed724cdb5d468baca2a3bc8514577a6a6b43f01409124706aa084ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4862048781102349b14d8884e7be3ec012d63f26b09579c754a9aef4b004b0f"
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
