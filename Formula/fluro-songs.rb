class FluroSongs < Formula
  desc "Search for songs in Fluro"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts.git",
  branch:   "main",
  revision: "a33a463077af21465b8acaf47048409d480ed6b3"
  version "a33a463077af21465b8acaf47048409d480ed6b3"
  sha256 "20a8705ca97e1915208a71a3b06c687fcdd5edf84aaccfa6c9f02f1f6aa2249c"
  license "MIT"

  livecheck do
    url "https://api.github.com/repos/bevanjkay/custom-scripts/commits?path=fluro-songs"
    strategy :json do |json|
      json.first["sha"]
    end
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
