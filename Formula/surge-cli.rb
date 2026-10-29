class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.52.4.tgz"
  sha256 "ee78096522439f5a1317a21d9184e6964cb457d597e133a3178beab81c10c0cd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "390354ea2e50537d3c975906cc5dcdb9a82dce7b60502694e74bf4e5fc708169"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9a2ed3b8787d3683fba0a2e4f4931a20c026b17c9327ae879ee4c9b74320eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faf13b1a61f27983bec163c0fb90645cb2397ab0cdee9164db3286d969921699"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f333dfc8f629a70daa59414f168571e0dd3589092b6d2b487ee8454ff79f64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9b747c4b0cfbf38222a8e948bb946fdec030d87be7ca17010d187c87ef8f102a"
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
