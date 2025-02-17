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

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34336e6ab08052fa46b6d651073d4a219652283720e7da6740a261c05042690b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0942b8bf8d0796d9915968c332acf7d6682c62aa55f1591d11a48e1df6c66ab5"
    sha256 cellar: :any_skip_relocation, ventura:       "220302b6aee69488da0315535751cb50e2842f48ee2356ce3c42cbc3783264d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4298eb05b501cb5601e49e9efafdbf0a7fdfc3a8e9745673de904d5f28ae8a9"
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
