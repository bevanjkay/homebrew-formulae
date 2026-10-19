class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.45.0.tgz"
  sha256 "1076d95404330b00d9b139428e58ee4e99244f5e597667e5bed885fb3e321230"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82739f2daca6328b78ad8b6688002fdea60b042e621f6f05ef8fa0639440c9a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce8f5fb245f832bb04eb77a3befdc47aac9beabf4c0b689ffdf696ec676111a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "601f61ec7039cc5f26312f886faa23856277a37af98ca1484b53145aa2e8d480"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "005aefacedf7fd98dcb28b9b1ca9372ea7e4e33a61ae0bfa4e161897b0ce973f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "888beae883d378b00a80c1916b00021a15296e7f0f34cdebdf76de20ab5dc785"
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
