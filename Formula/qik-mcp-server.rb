class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.45.tgz"
  sha256 "c9133c432c8779ab71579c81dfadab97784d0d669bad2e247dfa0351bdf86d46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d2ad380d706e1d1330b88a3a8eb0f58b1e2b449ec543d0bc7909a3f97519b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b1a3e0f33aa4eb8c9b715c4c86973f47bb5612c401fc09b882237262b95e04"
    sha256 cellar: :any_skip_relocation, ventura:       "3ac41ca074cbed902e624ea7fc6dc05755deb97e7938eb98397fc06869d0d15a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043a3df9479464386d3386101d994ed3120c9216e8bc5e216e47c37dd61a8cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ac1abf995fa46fa966d59b25e9bf4f3b2b176f7cf7fe912318b06ac35f6ec6"
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
