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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "553604cecbbc9abe53ec13574ca3b28cccd3d56819b9e9ef043e90d5bc9c7c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba7c76217e1f21529ff051e89d1e9fe689b8de1f0495eddd05a9ade20078f70"
    sha256 cellar: :any_skip_relocation, ventura:       "0630d0e102f0b24df76b28b0b9a76ba0ea51cc98ff916581eebfcb8e8bfc8639"
    sha256 cellar: :any_skip_relocation, monterey:      "4d51b77c33dbac0efdd148cb427a919a80572eab9964c3e00f92c84aed88716e"
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
