class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.8.6.tgz"
  sha256 "a89274bc9f92b88920cb57bfee3449e1ce83904c714ff32c5969ea0364e87b47"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4102ec63201f45810293210c015dfa2d353e1b3bb2b79de793c6124b33607fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1778be9aaeeab12c8625191df5d82c63515b3484962869cb8962d7015f161b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d219251b454500aee817cc2e0ee47d3160127423837a707d5be1ee72f5b23e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064505fc60cd0cb35563426ea6080f85a4999e20446d52971a1fb3a08ccc0b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c4e5208c060530688d37bbf0db4e0d1bb8abc6a0ab2b3145173294753af554"
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
