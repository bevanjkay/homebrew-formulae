class Bible < Formula
  desc "CLI for YouVersion Suggest API"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/bible-1.1.0.tar.gz"
  sha256 "f7465afb7095928c6c7af3a36580185c7c84853df20c887abc0ca9e3290cd409"
  license "MIT"

  livecheck do
    url :stable
    regex(/^bible-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1265ce8466dc7133e13c65098adec3fa06b3fcb2dff620f28419b594229b2c3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c131672dc8f06d9b349086ed9452c4294a4e76179651e4680326358d417b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c51347d29bbc8637dccdc3f4ad5153ae930538de51fa80f791bc7513f052ff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7f7f9fe9b652a107e7eb9d7fafe47f12089b122a1de4989e35a4c80379898a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc9c07f4a836d58ad749fea8e76e6ebad748b0a968347c4be04b95b566c1272"
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

    output = shell_output("#{bin}/bible john 3:16")
    assert_match("For this is how God loved the world", output)
  end
end
