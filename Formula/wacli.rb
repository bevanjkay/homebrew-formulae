class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "19100f83c2e210cdda3521dc4644e555fbff23823ea6cb510295f75d208e5197"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9a04a7dd56cdc2bb99bd62eb78434608cd614bc75c7d740dcbcbf91469e9dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25c4731e38da7a93b1bbb1c7b6c2996ec5230ad583d00a8f749a8a60c3663e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d882366ddf768e7ecc4b9cd79fc5ce130c44e3aeacb695aa18cc1197f5157145"
    sha256 cellar: :any,                 arm64_linux:   "53b3aa64de241135b84c4178f13c4f1f7a1f06ff67dbe1cc1d28aa8f6f197e88"
    sha256 cellar: :any,                 x86_64_linux:  "e7967ffbdd20c9bc9b8ba6c81d5fd5ab6c1f62784da0d9dc2b51c3b51b9003f5"
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
