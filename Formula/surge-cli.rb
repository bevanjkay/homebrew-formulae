class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.41.3.tgz"
  sha256 "9da8010f827f383940653de968f2f9ff2d0e600e3afd8551be398078789a3c3a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cd3f2ec18b601afbc61966992f0687d028e77346650cc8cf2edbca45314f110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc806422fdccb87043d68eedd626bcbf226da001febc0a7c46cbfa2e56f46b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9238ffa137316c720d9590956b07f7aea1b3a0a6493914b3afde32ea68a5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6113fe59b51c5f2c8eebec0c7f94f5d726dfd66f4a569831ce842cdef31f05e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b603bab0053a40c62c518afd8005118e998777cde36e17c50806cdc3d03328fa"
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
