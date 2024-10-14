class MasLegacy < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.6",
      revision: "560c89af2c1fdf0da9982a085e19bb6f5f9ad2d0"
  license "MIT"
  revision 1
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220d9b5a85ee95a6393ef6ab922caef4596a751a717e2dae240975f28b640a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9710343abbd55c7d367b8e1d17450bf86ebac35b1322e19b5973e56b2d505d70"
    sha256 cellar: :any_skip_relocation, ventura:       "9f15bcbab85d0883647f301f6fae0cd280551d2fbb504d66b92b7dc6f61e6f95"
    sha256 cellar: :any_skip_relocation, monterey:      "72e13bb368c1cb41af844fe0244b836624278cf11687ea366033cd6f9eaa538c"
  end

  depends_on macos: :monterey

  depends_on :macos
  on_arm do
    depends_on xcode: ["12.2", :build]
  end
  on_intel do
    depends_on xcode: ["12.0", :build]
  end

  def install
    system "script/build"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
