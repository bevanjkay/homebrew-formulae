class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.31.1.tgz"
  sha256 "d2910ff0fb777ef9edd4d076ca29c7086245b7fe78b408afa16ac7cdcce1ffe3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1abd05b9f52362a7d1c9d998ccae073416cf875307283d1f8f29ec1b5b92b114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98f173e427e2b6d46de93b9243c73c4e1f9dfa78fab6693cf579c3cd41d485d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46663aa5bce0d2dd8058177d0d7f6d37511822a886590e85d31735003d3026aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1794c0665aa3a77d01e4392a5069f727c39adfdb3bf7192ba1e1aeb441f5b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d9fb61609efe75471138e46af4e51ae29ab997050443a237a8d876e93f1f4b"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami")
  end
end
