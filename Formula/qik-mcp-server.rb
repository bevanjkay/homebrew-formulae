class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.25.tgz"
  sha256 "a83a8282c2881d1d5bb97891105e8608fccd58ad5477c5ace62eb34aefba223d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed99e43a288a9a9c76e7887c0b236b3d23d75e5f0ad42a4c2d8d5afa78106efc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a82b6d3c40418cc513e5c92e57f0c79513caf6ca332fa1809b88099b6ee473ca"
    sha256 cellar: :any_skip_relocation, ventura:       "40314d3658e43d2f3102bfe74a2ff652807350f449b25b16f280a1245bb84ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c130e9d900757312005ecc55ef4e084b3a38d773a59eb2458f1f9e190aeddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35fc0b3b36a881810deb7294fbf4d8013acaa1ccfe0955348af80e24a3c175a"
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
