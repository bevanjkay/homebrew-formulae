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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d459140cb86cc0dd95636b682e466701df7bea0d0b39e84c185c7745e40feaf4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02bc63c3209fa7656bab70e285fb47e2a7f814909630b0a5a747ccce411d9b1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52d89554e397640276e8c27ae9a22b9d20f4af18140a11fa3005eac0d3ce7d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d14ae6c48a1ae35e1d023cfdf2f93fef23d80333286291e7462c712896c477af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3f274a20214f7c420e1608ba29bb3cbd320d6813cb571669bafe1a830c1d3420"
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
