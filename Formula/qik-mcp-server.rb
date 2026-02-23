class QikMcpServer < Formula
  desc "MCP server for Qik"
  homepage "https://gitlab.com/qikdevelopers/qik-mcp-server"
  url "https://registry.npmjs.org/@qikdev/mcp/-/mcp-6.8.7.tgz"
  sha256 "816def82fb5eef21cd9096adf1b99c069391e5305160f2af1f8fd923b9a3a530"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed65cbd39b90154ef3b6369a6303202f3bd8bbd4168195b4ce7ccc29f2328de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "780cc4392c70252db1203c0dcb3502926133e961644e54bb1272edaf7019cbbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95c65ab49652b618c50950118433ba34273876ca31ba649b038feb741adca79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97262d2126c7763f676382690bbb8394c6cf59b65b5adbde5b7878f3ce27e60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af69fb079b75d19bd0508a93634e30c19e5ab8382327948a02bd9201c2ab9a59"
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
