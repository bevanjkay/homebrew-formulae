class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.8.3.tgz"
  sha256 "d99c5d0098dcd63f5b4059ed43d7a6d5a47f57a7222ce7d7b979c6418b68fb63"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ce957caebb7cbe06569d5a1222052031ca6775db6631941d3232fdf7d65802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6829db29f4f7c65b9a9ca7290e28b5384c0609af5dbd928a66cdd9b855c018fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b416d2693088d8ed1c5b2ee750e745491d9d35ef8a9f0b0cf4f50137d2f7ee0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf3e24df2fc2276b6c2ce27b55e8fa000a6d7ef50f7ee9cd050bbc40da0ee48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f57f366f62e1968deb873172322cdd21a43c9c56227ffdb7a49cfd5082cdc2"
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
