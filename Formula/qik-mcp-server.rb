class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.12.0.tgz"
  sha256 "29eddba1e358827aea7d58f6d06212f453f6c9655070d5efd4237e65dcb110ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01f9b1adce8f6966b58fcef3b3e933a0b6acba4a237e7510d8c9eecba5bf692b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff377805df0772774d703390ba91013ea61a70df2d19bddad9b59edd6c7a52fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc9da200e81730d6e3b2d4e54e49ac972da9f2edcbc6fbf141fe082b8bf36e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c28ccedc7bc6b01f8e2d1976fdd45b21f02814df111ef47906e78d74137acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc42de00a40bba45aac0a8fe4bfb99f7fa14def239b88428fcd2cc4bdc0a117f"
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
