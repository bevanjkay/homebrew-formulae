class Sendosc < Formula
  desc "Simple NodeJS script for sending OSC via TCP or UDP"
  homepage "https://github.com/jwetzell/osc-js/tree/main/apps/sendosc"
  url "https://registry.npmjs.org/sendosc/-/sendosc-1.0.1.tgz"
  sha256 "5fb846a19c7881366969d8b91ffe8ed26d5062e9294a391dd96a245b8965f158"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bbc7b7e9022ecb566134555dbb0de76dcedb5505d93fc06b8c4f7a9fe8c086c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf05a42294a39248c4c5f9caaf4594d2547ef9c598035ae5ef24cf66f2a0ee8c"
    sha256 cellar: :any_skip_relocation, ventura:       "cfcdaff7230a6c43586b25e7a4e9e2ea3f65821e67b049dc61c07c65e578065e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "249424b11b458108c559658fe2fc10318aebefa3fe041618e108a24fec65067a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d16822b546c4f2147c6db0457349b53223b241adf08b506ef385e688e0339f"
  end

  on_ventura :or_newer do
    depends_on "node"
  end
  on_linux do
    depends_on "node"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendosc --version")
    assert_match "error: required option '--host <host>' not specified", shell_output("#{bin}/sendosc 2>&1", 1)
  end
end
