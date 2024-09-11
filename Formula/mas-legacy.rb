class MasLegacy < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.6",
      revision: "560c89af2c1fdf0da9982a085e19bb6f5f9ad2d0"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "467c75e387264ca71d2169b487d2319e2a9d953445f518e012f601e64753fbd5"
    sha256 cellar: :any_skip_relocation, ventura:      "61103d216596928bdf17ae6f12bbd695e7fa8bc4676a1512938df4682a07297b"
    sha256 cellar: :any_skip_relocation, monterey:     "8b761b9d99057c89bb2eba0448fd30f9c24ce879f0afec6ba1027a7519ee18f1"
  end

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
