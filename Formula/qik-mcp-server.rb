class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.45.tgz"
  sha256 "c9133c432c8779ab71579c81dfadab97784d0d669bad2e247dfa0351bdf86d46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a542275cdffb21cd51a692d763db95429bba1600b30112bb55700441e4c216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24effc74823aa056dc1a9610b88558ed37dc5ba1ca612ee3db952bf9473f9dda"
    sha256 cellar: :any_skip_relocation, ventura:       "454f8ceb36fd82b1ae2bd3ddbe253635ad30dd9dfe43c2c85585ae2c7a1c2cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376abc819b1b071d63470dc9423e16eeed227986ed9f836693e68d9304448a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774899a4efecd50b5964059d6bbeb23a26e8f400b4f77e6a142978a55d5b7a99"
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
