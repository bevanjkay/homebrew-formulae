class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "774d5648c7d55c00c5d575a0d71880c6809e0a939483dc220ac1211df42e48fd"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72bfa05f29e9136b474570c9a6050e283985a7694b8d42b5be1205f9029e53da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2c36ba6c678cde3cb3b696a842a227459ee02c36c22b28686bee74908255d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ffca067677e87be4d554e27205e391b12b3b048f6fd180484077d152275f29"
    sha256 cellar: :any,                 arm64_linux:   "8039024b41ce9573c7f308f98312744705b92a2c01a59b25235f1cda75acca06"
    sha256 cellar: :any,                 x86_64_linux:  "4825b236f0156d8ec40ea58fc817d7189cc64ae115a4f5116c0c91063fe6f22a"
  end

  depends_on "go" => :build

  def install
    # go-sqlite3 needs cgo, and GCC 15+ with glibc 2.42+ treats missing-braces
    # in Go's runtime/cgo as an error.
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_CFLAGS", "-Wno-error=missing-braces"

    # Setting main.version alone is the source-build path upstream supports;
    # main.releaseLinkerSetting is only for official release artifacts and makes
    # the binary report "invalid-release-linker-version" if it disagrees.
    system "go", "build",
           *std_go_args(ldflags: "-X main.version=#{version}", tags: "sqlite_fts5"),
           "./cmd/wacli"

    generate_completions_from_executable(bin/"wacli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wacli --version")

    # Confirms the sqlite_fts5 build tag took effect; without it search silently
    # degrades to LIKE.
    assert_match(/FTS5\s+true/, shell_output("#{bin}/wacli doctor"))
  end
end
