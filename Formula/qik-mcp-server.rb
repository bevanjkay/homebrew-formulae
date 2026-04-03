class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.16.0.tgz"
  sha256 "1825c370fab704e333f65f4d72649a0ca7a5327345f9c2f3f8efea57ba573a38"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fc34f6d956a1ee6487bd7c33fd17481c584e4e79d57bc7790a91079263d0016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3cd648f54aaf118efe0dd860fc64f565d01822fac4b472a953160f49a74d44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ce2eabf61cb4f5d8cfd13c62cc6ab66339e2abbf83333461eb41db85b482320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1333a95e3b0a3975cdcd1ba6699cdb3f475b392f94230333a56f5114d503b267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcac2677839b33facf3be1edb321bc49cbea4ed77ebfe9c87b990456c9c08fdb"
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
