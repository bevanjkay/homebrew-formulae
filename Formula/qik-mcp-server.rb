class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.6.48.tgz"
  sha256 "2c7113e0889cc95dd686848ce56261a8f043d8623a0f83cbb31cefa2a6c53afd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22af149111d322120564f75d9babec099d83cad10d25797cbee5b65943d892b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a162f480e367214b3c499192c590d4e2b295ad986324e064754f0d369cb07e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8e4b5e2d8d181c47437b93acdcb635167a84e8458005e6aa8786a8c043ea4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "432435e3541959857ec3a9025bfe6ef99e493a16300f61a7c7afa57b03a0a43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84453a905d3fc633b1e842174fe85110028d0a85452c5b9764696af586b4e6b"
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
