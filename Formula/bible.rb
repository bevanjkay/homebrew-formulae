class Bible < Formula
  desc "CLI for YouVersion Suggest API"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts.git",
  branch:   "main",
  revision: "1e43e8e40cdac4734747362a34fce46f2e151579"
  version "1e43e8e40cdac4734747362a34fce46f2e151579"
  sha256 "20a8705ca97e1915208a71a3b06c687fcdd5edf84aaccfa6c9f02f1f6aa2249c"
  license "MIT"

  livecheck do
    url "https://api.github.com/repos/bevanjkay/custom-scripts/commits?path=bible"
    strategy :json do |json|
      json.first["sha"]
    end
  end

  depends_on "deno" => :build

  def install
    cd("bible") do
      system "deno", "install"
      system "deno", "run", "build"
      bin.install "bible"
    end
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output(bin/"bible john 3:16")
    assert_match("For this is how God loved the world", output)
  end
end
