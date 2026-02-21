class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.27.3.tgz"
  sha256 "71430d04a980eb61a1c866256f5a2c2a40c2c44d43efef4c08c5b0e5e76327c4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b09e90993675b500f4f3b4cce0fa96035bf9016d7bec0aaf87cb8654f29564e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78025cc402f6479c01fd73dd0424d616d214c42c35c7cfb4c3c8b05c955ee1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f9763cf249b2bb1aca3d8c8220275092d25db2579cca649cb2c200367a26ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdadcf01cd459cc5533d67e8d84fc33b9a5e94f70d7e0f2fae33cba94c5dcc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16208d628b77b3795fcd7cea2945d9b670015dce5a1bf2b797535f590ee494fb"
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
