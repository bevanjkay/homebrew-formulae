class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.53.0.tgz"
  sha256 "8aff763824ce93bf1461bd15a668b9c6306a86684b6d41b6929dbdf9cfc0dfc6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ce102f59a84f4e28f7e079f5d619628230831a743a02cd648fb8264bd2c0924"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cb72131db16e55e71f8e68d43aab7c3e8261424719711782bd9a1c4ce9a2065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "606a831af9858f122dd2a37133ce4b8d1a6f49cccbc1c657618a379743923a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0f4a24c0d0f38f01f16cad88f305eede365407e8e89a14a11118702ab895b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "60948f0b8c11da5dcd1d47ad3c0ac27d210bf6a2d88ae4a9db22209df332ff34"
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
