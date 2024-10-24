class Sendosc < Formula
  desc "Simple NodeJS script for sending OSC via TCP or UDP"
  homepage "https://github.com/jwetzell/osc-js/tree/main/apps/sendosc"
  url "https://registry.npmjs.org/sendosc/-/sendosc-1.0.1.tgz"
  sha256 "5fb846a19c7881366969d8b91ffe8ed26d5062e9294a391dd96a245b8965f158"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendosc --version")
    assert_match "error: required option '--host <host>' not specified", shell_output("#{bin}/sendosc 2>&1", 1)
  end
end
