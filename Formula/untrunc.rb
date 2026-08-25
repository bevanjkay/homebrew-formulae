class Untrunc < Formula
  desc "Restore a truncated mp4/mov"
  homepage "https://github.com/anthwlock/untrunc"
  # Upstream tags only a rolling "latest" release, so pin to a commit.
  url "https://github.com/anthwlock/untrunc/archive/9d86ec9ef2ffed1bf8131abe80742c0574db52b6.tar.gz"
  version "2026.08.19"
  sha256 "4e046f36bcd0195aa80b59e15051cc06fa58c5262e1da62005c5d8593e76153c"
  license "GPL-2.0-or-later"
  head "https://github.com/anthwlock/untrunc.git", branch: "master"

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
