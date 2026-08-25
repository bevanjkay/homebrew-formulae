class Untrunc < Formula
  desc "Restore a truncated mp4/mov"
  homepage "https://github.com/anthwlock/untrunc"
  # Upstream tags only a rolling "latest" release, so pin to a commit.
  url "https://github.com/anthwlock/untrunc/archive/9d86ec9ef2ffed1bf8131abe80742c0574db52b6.tar.gz"
  version "2026.08.19"
  sha256 "4e046f36bcd0195aa80b59e15051cc06fa58c5262e1da62005c5d8593e76153c"
  license "GPL-2.0-or-later"
  head "https://github.com/anthwlock/untrunc.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any, arm64_tahoe:   "d873e6383a2e72ca5446165bb1d8fe10982d2263c08de15a5230a5cd7854b56d"
    sha256 cellar: :any, arm64_sequoia: "df02c890c87a715cde1aa59fce1fc5347781a1fd801bcefb300b21d8a7c86125"
    sha256 cellar: :any, arm64_sonoma:  "4ca001194a0f86314a3fdae9aec44e8578dc0ea8ae50ab45e1efb4a78500cf54"
    sha256 cellar: :any, arm64_linux:   "be32e4d63d5c1c560247fc3e177210c2b433a011c301ddfc61090f895a856e2a"
    sha256 cellar: :any, x86_64_linux:  "2d645de1ac7b8b637839259f221c79955c0542ff9aad24ffa1edb0ee46956960"
  end

  depends_on "ffmpeg"

  def install
    # Set these in the environment rather than on the make command line:
    # the Makefile appends to CPPFLAGS/LDFLAGS with `+=`, and command-line
    # variables would override those appends and drop the FFmpeg libs.
    ENV["CPPFLAGS"] = "-I#{formula_opt_include("ffmpeg")}"
    ENV["LDFLAGS"] = "-L#{formula_opt_lib("ffmpeg")}"

    # VER is derived from `git` upstream, which is absent in a tarball build,
    # so pass it explicitly or `untrunc -V` reports an empty version.
    system "make", "VER=#{version}"
    bin.install "untrunc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/untrunc -V")
    # Invoked with no arguments it prints usage and exits 255.
    assert_match "Usage: untrunc", shell_output("#{bin}/untrunc 2>&1", 255)
  end
end
