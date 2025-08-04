class Ladybird < Formula
  desc "Truly independent web browser"
  homepage "https://ladybird.org"
  url "https://github.com/LadybirdBrowser/ladybird/archive/4e6da3b14acfe39e995cf616349fc7e9efe3fe29.tar.gz"
  sha256 "4e67c92b345f5f482a839bb4983e1dd7a659e0254a49033171134ba445215d6f"
  license "BSD-2-Clause"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system true
  end
end
