class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.9.tgz"
  sha256 "fedbc453a3c6886364ff12a722e1c7d4224828c841dd56d6e47cdf4f62c7bb45"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink "#{libexec}/bin/mcp" => "qik-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qik-mcp-server --version")
  end
end
