class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.14.6.tgz"
  sha256 "38fe5bfa853c4c75b149b7a5842e272dc66621f2e6717360e721a04ee3e8216a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2a5867b0582a84ca7869ed20c58092b9c1d75dba8fa3f48d80ea68b1ebc81b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045f602bd0e65b70ecda28a8d712424bcf23b7c60072e7c1f47e0a1b983004ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50d2e144c940ad664a82d6c1278786736033e306d457c953edba94ffbd17acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5838602ecabc78f6bb00446c02deabfbdf76663d30ac39509db380e42008f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9ecd4459e2eab5f4e7fd9a228428383c8b8ca5f65152a0ffe7c19a336b8a85"
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
