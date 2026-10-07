class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.44.5.tgz"
  sha256 "3445a5d6f00a61b32390e73694198c1c46c95c0b41d1f7d05434bc3248671edf"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557d04add71c55e7619d209f2d26ac600f183ca5d50465f092d8fa41ce251980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4e7ee3d893bb2c4a3200191f73372a59638bb00dc3aa0be703457b2947a03ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9265a55465debcf405b5514a780ac3b327eb439678656752a65cffa3dcf33f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94232e073d16cdd73d36a3cad1b461e279496a6d0880ea27e1dc8c14620e0c50"
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
