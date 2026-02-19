class Ladybird < Formula
  desc "Web browser"
  homepage "https://github.com/LadybirdBrowser/ladybird"
  url "https://github.com/LadybirdBrowser/ladybird.git",
      revision: "ad92622cf496a7ed10aa55c236486ae079f9b6e7"
  version "2026.02.18"
  license "BSD-2-Clause"

  # Version is pinned to a daily commit hash. Use `brew livecheck` to check for
  # a newer day's commit, then update revision + version manually.
  livecheck do
    url "https://api.github.com/repos/LadybirdBrowser/ladybird/branches/main"
    strategy :json do |json|
      Date.parse(json.dig("commit", "commit", "committer", "date")).strftime("%Y.%m.%d")
    end
  end

  # This build downloads dependencies via vcpkg during cmake configuration.
  # Network access is required. If the build fails with network errors, retry with:
  #   HOMEBREW_NO_SANDBOX=1 brew install bevanjkay/formulae/ladybird

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["15.0", :build]
  depends_on :macos

  allow_network_access! :build

  def install
    ENV["LADYBIRD_SOURCE_DIR"] = buildpath.to_s

    system "python3", "Meta/ladybird.py", "build", "--preset", "Release",
           "-j", ENV.make_jobs.to_s

    prefix.install "Build/release/bin/Ladybird.app"

    (bin/"ladybird").write <<~EOS
      #!/bin/bash
      exec open -a "#{opt_prefix}/Ladybird.app" --args "$@"
    EOS
    chmod 0755, bin/"ladybird"
  end

  test do
    assert_path_exists prefix/"Ladybird.app"
  end
end
