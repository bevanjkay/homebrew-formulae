class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.8.6.tgz"
  sha256 "a89274bc9f92b88920cb57bfee3449e1ce83904c714ff32c5969ea0364e87b47"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "522922ade6b201e5bdbb9198599ef0811f5eddd9fbf20ce7531231937d294f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f141213e8b71b5d89c0259b66926ecbe87b82738b680fc56debc668fedd72dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59e51b5d2cfb26b72ec3d0945027b75969700e4ef1d5e49176e577383724b5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9533459d527e39cd5f10ec6918237f4ac324769f3189b7a85c9776e617f273c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbbfba404ed0622eecbea99f12104a4e1a1c575ce9b99e250064d7af07b2f1ba"
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
