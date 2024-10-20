class Betterdisplaycli < Formula
  desc "Simple CLI access for BetterDisplay"
  homepage "https://betterdisplay.pro"
  url "https://github.com/waydabber/betterdisplaycli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "62f42ccf87b9352e6e8d1bc79542f4b0b4f40df507b472c191038edc0e460838"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d347afd43092915803d86be68355b33417b185a9c428219009f6c28b4345dd92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f0d35afebcba61023700cc992f0b6919303f8cb2f208fdc94e889f8a235b19d"
    sha256 cellar: :any_skip_relocation, ventura:       "b8d52fcabbfc267aa610977e9eda6da073698fbb14063b1c36a3f221efbff3ad"
    sha256 cellar: :any_skip_relocation, monterey:      "888ae4ba3b3d5a3bf69712e82cb1f9ccf4fc575b0ba60e8d2ab0d3c8ff4e7e1d"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/betterdisplaycli 2>&1", 1)
    assert_match("BetterDisplay might not be running or is not configured to accept notifications.", output)
  end
end
