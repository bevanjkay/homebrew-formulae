class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "77a68e18771255b85daac72ad11442f0bac9c8b10965cbb29cb08e91e47d7934"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5047856d2280825554f5e687a8faaaa45c74e4c4b7ea44f1ffa1ef61fed5369d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06cb7eb76d15a8c605530686716adc62d8e0fd67d47de739cb5759ef758d8d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fe0ecec2192688451d0b1e84143fa54089644593533ec15ff881e4b24543859"
    sha256 cellar: :any,                 arm64_linux:       "2457c91094e6a830bd2addbfe3e88a27d20ee32466787e2aa669873aa691ebcf"
    sha256 cellar: :any,                 x86_64_linux:      "d8cb5d771c5424bfd62f9c4ab62ebb82573c372b704769f6d895f267f5a40fb9"
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
