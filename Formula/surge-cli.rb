class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.30.0.tgz"
  sha256 "32d5f8e287c22a8190f45c2bb2bba371f94fd39066358f8c2f2cfd3bc925d7de"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b58c41d8f1c54160f010ea0d738ad55737fa235bdfb7a400ad9679b0e8acc1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2fc9fa810c2d8fe7327ad5bb5abbe5248c3fc39970591dad39b0b7e3b59e364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cc687ed929588f96cbcf162f2c4c48b8fef936fc167f7ea3d2e00e8f9f6376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb033452d7a78abcb5d13a3577dc91ce4d3a6a81aa164e5526df0c9a5ff9e8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b7f917bf66f6782fac50323550ee66334acad55c4178bbc2f0d50a567999c2"
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
