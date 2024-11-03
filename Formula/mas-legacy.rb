class MasLegacy < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.7",
      revision: "4405807010987802c0967bbf349c08808062b824"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad2470e31d180b57be34ad24e357752b5ffbf0634344a7f3d77536147466a05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a30812d01977ec980c414857c6c14dac6032e16360c53c0dfac5e35e5b9ca24"
    sha256 cellar: :any_skip_relocation, ventura:       "4e7bf36510b99b416949f16a1a900377cc43a45b462564b17295a7c7feccbfad"
    sha256 cellar: :any_skip_relocation, monterey:      "0902cd2ab0cf63326c9ce902726a10965eb73d76f5303f01a88cd3d34b3e6879"
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
