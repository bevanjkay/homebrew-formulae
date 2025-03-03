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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e671d509be1910b1e81805f9cdd07e9c1b2f8700afbbbc7e1dc9b345aec188ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee1aa46e6ca3a4b1217a9917dac269f9daa8446f26b768e68fb4604c9f92a0f"
    sha256 cellar: :any_skip_relocation, ventura:       "ed9b34e2532bfd22f2fb94dc7019f8d7cf098b07aa4496e1e24c21d25a12518a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22e473d695b67f6b286cb58450292cbfdb5eb5c7048bdbf9275224cb0acfdc3"
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
