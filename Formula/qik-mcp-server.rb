class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.14.5.tgz"
  sha256 "d8d1bfa06de926b8f915bb9303646d0b4d6017895f96550be3273a8d7ca09151"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be39b66a54cf069ff3d355ad176385ef3d1100fea79f4c4d032fc7773955491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9042d8fd47b4dd61dc17562fea5dac3f439a1fc378ca7dfc4e04109e7612034a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2ffd57ad7ea96a2379cc7943a80a3b4567a41cbc2b6bda65db41e8f4ea75ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3fbc5ef22821112c60ffc5c8d53edfe76f0f3377bc67f761f826439717cc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d23aeb7b5a7c16212ad428fdb31c5d9fa318c8b6b02f7b10370d211007acf84"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink "#{libexec}/bin/mcp" => "qik-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qik-mcp-server --version")
  end
end
