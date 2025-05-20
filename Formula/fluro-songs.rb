class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-1.0.3.tar.gz"
  sha256 "14c85c795b93edb04288f170ea98de053a83829696d3bfc991a3e81cafdefea1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13631a2a951399bf5a1f31e599c1a34f7a290fc83b51f11f466a4b1b42f2a433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350d62a1d76f74e44230338eeddad238ce407651c369cbd989596fa7d0e3dd83"
    sha256 cellar: :any_skip_relocation, ventura:       "4d6fe1e8f6881d06c4f9b0f7592d923b9020b5a8182d121b617ae82791d38d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51654e73419f012637dc1a7135ee1c91ae74d6484a9b40ba809d031a9aba4e62"
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
