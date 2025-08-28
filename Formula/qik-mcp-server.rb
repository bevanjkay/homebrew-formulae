class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.25.tgz"
  sha256 "a83a8282c2881d1d5bb97891105e8608fccd58ad5477c5ace62eb34aefba223d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae7c7dfdff8fef0b6c24cee20d2eefc49802d36a1b92aafedf4f6528e01d0576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a1b3910643368d8dde891977b636eafcc4da507b9f06c1a2d9691792e5b834b"
    sha256 cellar: :any_skip_relocation, ventura:       "a14bc877d1f5e2c71f39c54b059ac7c89ae45c3fea092cfce03f5ffc83980c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab45d5aafc20e0a97fed9fdd9867b326c1a15c89f360944a3a8468c28a07b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fea41073d9a2ca5ee76900605d03f001c55f12f1211764fb56383523a530cb1"
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
