class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.41.2.tgz"
  sha256 "a6e0b25cdbea9d64ef0cf2ee1cbf19fbf7023529cba4015c736d825695cf0f6c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a22284ceda6d5656000e118d0d2c95ea8caa98bb5eea83e70bc5d1121befbeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd06157d30e4ccccb339e1882c15668a6e197884e636922568b77f39c6606c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c168e9b33b868f8b04378ee9674a826d721e0d8d562934e6ba67bf2489a2e1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a4517edf16c93a01bbfd843d1ca02cee268c4feb54495a172d79572e24a81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb51ab6139a25901f1327c973d660578ec27e9e2887c82f03c63bedde9310e9e"
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
