class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.9.tgz"
  sha256 "fedbc453a3c6886364ff12a722e1c7d4224828c841dd56d6e47cdf4f62c7bb45"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d73cbcb2416fc4aba092443469ed052eac3127920575bc5487aa13a98780e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850ec230a0fb77350c6a511042e61a3a7bb8dbc075fdd3ccc019f466af9e4ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "683986ff866e5f334aff9f385cac4faf1a7e6331caa928d302390f389e9991e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2303feec85be80cab9bfe24a52be43907f3d2b7e145ba94f8e667d60a4c4112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b2597c2482f64c8d024222ee872720b7d250ff8dd1bec452f041f1403f43d70"
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
