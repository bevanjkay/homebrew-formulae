class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.24.6.tgz"
  sha256 "becf2678a30ad17c8384c36382f5c62e27ce73a9ba184c8664cea4ee40053ee0"
  license "ISC"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26784fe901af576fcea67964d49fc8ad26f5474d7c4a16122023a543d96760d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e01d6311d2fe5da6d4a6b0e9dd30d7c1cba818ed98db9007359eff8eab524ea4"
    sha256 cellar: :any_skip_relocation, ventura:       "4e1af24e3bb5025af7d30e40b471bd58997ea0a89779cadcb2a0dc74a867c13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cdf200aea0d63a194fa9517516dd644aae273c5f77a9f566125dace4ebbe9e"
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
