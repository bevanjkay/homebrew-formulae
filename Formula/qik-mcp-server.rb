class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.48.tgz"
  sha256 "2c7113e0889cc95dd686848ce56261a8f043d8623a0f83cbb31cefa2a6c53afd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06a54cbd8cffd39ce8818d3a147b9f6c318fa3e306e66a96a732aedefa855a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d943561fdf451f849b0a6d3eea58b76b450e5b1a04e4226fa42c8e7cc58bb0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e533555bb19cc0ea5dfd5f14218245c891febdabb5752234330fcefd8418805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f2d158a094c0f69e3bfa9d17222c676d2d307574825fbf2721fd2d10cfe44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebd1afc2cbcf8530fd5b2426aba44c1c36087306e9604c56650a557cf62badd3"
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
