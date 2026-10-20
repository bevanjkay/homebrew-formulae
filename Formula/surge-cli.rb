class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.46.0.tgz"
  sha256 "b5800a3c00e28afd364122786c13d9555e9af1e6eeaa31d62ecfd1486e95e804"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9484f20d953eb08a42c540ec60eb19cd9f5ce09f1e43244cc847a997e970f33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5771427564907b9b48ff1e6200f0722fc07a779d0772e47cc17d64a3050757f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c2325915767a75bd90baa00a5f0b698bff9879775a02eaff512c40df0414bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b18f8dadd16924353457536d9121c05fd9b75488acac4f6a88330812957690bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6806aef972b0ede59821d7aaa27d9af7bedb0edd047d77e62c5c22de411cc278"
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
