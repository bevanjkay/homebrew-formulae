class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.16.0.tgz"
  sha256 "1825c370fab704e333f65f4d72649a0ca7a5327345f9c2f3f8efea57ba573a38"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c7e80c32e4d5b2146728f142d0bafc741998eb79e01e848d59f6b788ca74657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca795ee43407fd0bd4f1af877b3eb151b3cc2f7f8dc2875e5acfe336d132c6c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d8d0a6dbbe73dd510192a6bd20b629ca2aae83766d592e420d405e0206d8fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f868498e3113878b0db4b0dd59b5e5b193645ad7f213fedd4d4f218c71d1cf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf0966b10fe9969d4a9263f5518f81cab18db53bc432e42953c1a226cdee47f"
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
