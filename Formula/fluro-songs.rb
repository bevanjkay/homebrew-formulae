class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/aee3201c71f7e6ce52608884d16802f63ffcc350.tar.gz"
  version "aee3201c71f7e6ce52608884d16802f63ffcc350"
  sha256 "d8f34d30c69724b7dc71e91d32c6245e1fac5147c2f68ca5b8c225bd81ecdbe4"
  license "MIT"

  livecheck do
    url "https://api.github.com/repos/bevanjkay/custom-scripts/commits?path=fluro-songs"
    strategy :json do |json|
      json.first["sha"]
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16447436f46e38e6b4b9e6dcd1a66a77ef1185a2072bddfb3f01ef06732bcb80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1951b7b10b3f94b376f93dd805e2b877333701f363546b03bf9de630743189f9"
    sha256 cellar: :any_skip_relocation, ventura:       "61e1217ceb3502e7ae937bffba76a5e5415775f7f54db07ebc3a156f547b346d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f56d1934b44f4ff8cc791f87da612c523d928ae6ff5e2bf95d365b2bfe2de4"
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
