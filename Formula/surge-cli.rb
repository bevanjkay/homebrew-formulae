class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.58.0.tgz"
  sha256 "822948e859a0cc36dc5592a717e2b0d782b72386695c3732a9fca238e91296ea"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    manifest_sha256 "25c86c9ff0d6224d1df98ce1eb9ea633946439645dfe3d8ab1601acdb43b7dbb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d30f515374e9884fdc37eb85e51d21d1ee7b1e0bf840e8a32e50e9c041962a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efd5ef2a8a33b7b89fb365c12e9ca36b90b56d6e3fe75f42ab3e8638b24dea17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "488716323749444dea27ec140cd34d6a4b1791058231576c8b668a4f98295c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6682e074d3c651a7e3eb1afe5755a358b304bd232c07692386bab62377d63090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0b9c5aeadb925168c20d3201050ae1419e527d063e22fc095c48b9b0c34c7f50"
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
