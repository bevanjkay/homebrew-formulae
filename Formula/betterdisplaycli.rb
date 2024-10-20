class Betterdisplaycli < Formula
  desc "Simple CLI access for BetterDisplay"
  homepage "https://betterdisplay.pro"
  url "https://github.com/waydabber/betterdisplaycli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "62f42ccf87b9352e6e8d1bc79542f4b0b4f40df507b472c191038edc0e460838"
  license "MIT"

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
