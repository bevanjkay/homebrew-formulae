class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.44.3.tgz"
  sha256 "11b1ada92fb277a2babb3e875df8efc1f84db2b7ae59ece871b915fbaaea0bfd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "727dc970402aee3ed1b269d6f06ae47db98b4c36d45b70ab1aa0a984db69f05e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f3f2c64589f0bc5a34d3c3f115c46e14706d635d338b2d069a79d5d77ca668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294f36e440e83ec9c0e4ebf2873dd36c6bde15d1120f2eb5402bad26b94bc021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2b6742e4a326aaaced2331cfe828813b1fde7e6101ed84f008f5331d0afdd6"
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
