class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.8.2.tgz"
  sha256 "081534645e4602fa94cbd66c201ac502b8413c3e5a2a0b1ed2cb49c643389136"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b497334fe121a9f789f25d361d050159eee48c7c7e3d6b5bb3f4bbbde8bf0d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8ca90bfc03dce39dfaca9a8f1636354b4f882b01750fbb97e6d096f24801ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18bf1d685f84360fdf17a15025cd9cefddcc7bb52abaf0df83c2ffc7d25d397b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a149d93f58d1517ca0d2f1865f8bf5d750e18ea5c882b991ec3febdb251a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf96c92fc72afe5e0ea6b23acd8c365ab8da508aa2a824a3b64bdb1ab763e76b"
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
