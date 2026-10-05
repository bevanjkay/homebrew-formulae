class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-1.1.2.tar.gz"
  sha256 "d3646470413a698aae66563738f966a99ed33d700071f8e4057ab16f5dc90a73"
  license "MIT"

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8dc6b7e22a73947fd543e06a6826234b59bd84b3e6d73fbf73652b46ef6f11c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6571394c4a1da1a82e7f0cc9c02bcfd918e020898baa97c6305857a89790b699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3af5cd01f895485e148387f59cf962455c51048836ac6f85d12074b45626182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a715bbb46533a2c2afac894668855d9cc975f9d79c085eb7c6a1e3e9717e187"
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

    output = shell_output("#{bin}/fluro-songs test 2>&1", 1)
    assert_match("Please provide FLURO_ACCOUNT, FLURO_USERNAME and FLURO_PASSWORD in the environment", output)
  end
end
