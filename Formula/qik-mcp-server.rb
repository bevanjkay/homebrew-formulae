class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.12.0.tgz"
  sha256 "29eddba1e358827aea7d58f6d06212f453f6c9655070d5efd4237e65dcb110ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9ba7bab595c7ca92343a27bbe66659ce59fbdbdc03a10d0e6d972407f5463a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3dbd31f2ee1e1a6786029121164ac40f86e75601f2556b0f65b079c0e6c1ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "992c7583ef2248c5727726c57ef1e72e71001e03eb1b8ac16071589350ec8cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa4385ddd5ff8147db60e5f7a3fb52a39bdd994aab16a7777f83a24dfe17605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3298901c8c6cfbeb895e7a60e41917c2206f4118a997752a3433b472a8a5d9ad"
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
