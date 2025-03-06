class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-1.0.2.tar.gz"
  sha256 "4f1ed3b684ca4bea3914e839a8f4a74167f225417fe45689b623e5b2c91b5d27"
  license "MIT"

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bcae053c3fe1d17e1f38beebda5de0576c64643dcea78fc84da2a1ac8db81a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5de057ff935f82a463fb8a538089dbc102066e5f6e079c4c5558a3bc8cda2e2"
    sha256 cellar: :any_skip_relocation, ventura:       "0bf1ba51d2fa62be3f61a1fbd1913a5f234b05ac134c110803f63825378fbf46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3d4f4a8dd6b012a6d810c9b7ec6f33460d59c47d6b4561fa1623cb52c24bee"
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
