class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/fluro-songs-1.1.0.tar.gz"
  sha256 "9bc67c7dba8f9ecbc57087923037bcbecdc9f596e85bfc5005bb37a3e853a24b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^fluro-songs-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca0572386266389378e5cc7027f6d4604e4076afcf5e94cf9e6af3e0753a9091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3681044d03ae7649cf28fe90b3a0ac8a3290c4e47d84923871293a892ac2e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d6da167618d33de545790c28f48baba574f62a5b1ece7ef40dd6a099e67d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee60fd1bc8df5c29b89f397062f7948393c15564d6805ba52331cb2c9152e1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed315b5115e00ca0c6fc8b9a8a4547bf20e40f03798272efd002e562a3eba6d9"
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
