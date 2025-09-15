class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-1.0.3.tar.gz"
  sha256 "14c85c795b93edb04288f170ea98de053a83829696d3bfc991a3e81cafdefea1"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c69735491bf6d7fb05d4134b803aff25aa21f84999e404307cead3877972c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7c887e8cd5e1a525298a53521dc49e5545411c026ffbfc7a67b46915d71766"
    sha256 cellar: :any_skip_relocation, ventura:       "fa873532784a3adc4bc00c2dac9e7f02294792864c173551333ab78673317afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c6c449fe2b15b3ecd59e8bb99f1e71469a7eae66d40a1c1a0b0ab623ca0197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0e5cc8b0176d449b73bb64b4562bdfafcded5f4132d81bf239301523774a47"
  end

  depends_on "deno" => :build

  def install
    cd("fluro-songs") do
      system "deno", "install"
      system "deno", "run", "build"
      bin.install "fluro-songs"
    end
  end

  test do
    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output(bin/"fluro-songs", 1)
    assert_match("Please provide FLURO_USERNAME and FLURO_PASSWORD in the environment", output)
  end
end
