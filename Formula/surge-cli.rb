class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.32.1.tgz"
  sha256 "50e45ad5978af9732d54473d2f89b530300c044d1da3242812fd5b396b849128"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb597a2a2e677ea9344a8fb6b759a549fad66185d0499eacc46715dc01b8d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4402cbcb4cbe24fef066bfb6e650afd7aea02203485b6d54c1a9510dc6548f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96767ca110643839e85d453e30ec33bea78556f2c606dff19a2459e9b35c2458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2b630e43f20ca8dec4ecba339b35793be4dcbaa1dd645f818ac337fe32f912b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ecf72c94c9855299eb4d2a248d7116ad97306694d69839e0291a5642d8032e"
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
