class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.17.0.tgz"
  sha256 "e3a5e58f91dd9a44d61881cf5fe061419794c1019d8add67da632f33604cd9fd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a66a77c07c368053ec3160adf2f95b12f043ec83d446a8d5d7e79a3fffb5b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14365962a44e49a9749b18a201b691afd306599c878bac0d136dc4d05971691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af208881eee91046629a9ece2ac623809744520ff80b8cdc66630b7370535c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5b75bf0e16031809166d68e47e385b396f0fe8477512cf905e7ad690692f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c887a012e8b801d398aa15c2f86987afa7b8d2c6d701fca3f7243b94a3eed6cd"
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
