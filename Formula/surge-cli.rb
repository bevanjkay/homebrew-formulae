class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.52.5.tgz"
  sha256 "cd6bece365bda18bf1f69d1212be6c1af175363a7302438a62596a35f20b817b"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea8e25ea43a7523b688790b4a3a594784aad9f2d36571f6a0a169c0dae3d0929"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71e4eebced3f75b4aa7764c1048a981508c1b2eb7a06f8e2e783fafc5698671f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e916744490db00ff62b0193b8100fb49432803ea8769ba9bb810e6d24ed2387"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1215cf46839fb3d92cfb11dcf25841573639973dc8946c66eb701991a82ff93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "07a8e238440a050c5272218779efc337c37fbc48e4b081358d6d2a07c1d7e4b3"
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
