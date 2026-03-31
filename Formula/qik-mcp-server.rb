class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.15.0.tgz"
  sha256 "81ee550d7f7a5bd1468fa5d8b2372911033e3054877ed22cb45a06d4dc3cd9a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "225836ee419a6c4d4a1a2f2202b3a33b614a72c1834aab7b487628c5cd0a3c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f266abc980c7e2bbb89cd6b09c9684717cbbe3d81f4de1bbb60ef5dbc46edb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262f595daeb32d4444813a9c9d3fcdc87ac92ea43bdd8fb4956044813af7e014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9f0ce426c387cd1c42ff2222fe028c7e7cb350d1cbc5a56f25092565138f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f38d8b9305ac4e5cb072e1ec6f7b56889844e77684a4a0a263426cf6364ed8"
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
