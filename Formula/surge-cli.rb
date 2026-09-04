class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.44.1.tgz"
  sha256 "931b32dae23d618f5dafcdb4bfca10d42ac021bc4f2d07323589528cef7c824a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b6e6ec542c5723ce3a496d9f85a5444b5d5f58bec606fa7df53d75f6ff8728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303ef6863fe93245d55e2b20b8316de7de9cabc3f1b519d676a9f76e12163fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c15b1c9e437b73fde931e52dbc6ec93aa0ac1985d064c762625402eb52c3be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4937ce08b4902581cd3f7660759079e26d10bfd07c1576d89900dec90ab58afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e7303fae40339354ab9b0aba62e32a5bea359992fbd66033b45da45ecb4d00"
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
