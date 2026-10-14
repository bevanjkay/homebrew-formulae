class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-2.0.0.tar.gz"
  sha256 "0ec3d9936e1f78b7816c5c8e7552d78213a32837e47e2fa1938bf4914b639fed"
  license "MIT"

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2648960be5f391b2c948e8e7bbd9f2a7d2acf8baa87d35d945d626376dd12f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df286cd49c47cb107c47da1715d193d08f18c614efc76394925dd896b054c677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f04f4cf7b9f73549517229211bd765153cef91578474445ecb243fadcc39c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32b2736e48ecc2f927bb06f4dd1a63e520e2115cb26ccfa96f0318b9814c581c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5f5a5ebe23e0b476a1c3dbcbeb0173b3548c002919277771b32d12a00e01f7c1"
  end

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build", "--workspace", "fluro-songs"
    cd("fluro-songs") { system "npm", "install", *std_npm_args }
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/fluro-songs test 2>&1", 1)
    assert_match("Please provide FLURO_TOKEN in the environment", output)
  end
end
