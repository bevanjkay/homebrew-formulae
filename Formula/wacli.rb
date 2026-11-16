class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "62692e4c30275b4979431e907312dad0af4b16b45ac5616a74694cf2f8b46d74"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "674d649e566c0182f870d0b8ce3a0c649372870389315770abf19d524a0d011a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07ba0a0668acf58d94e290f4eacbd69c24b762f1f677a2fc6314a79f6ae32046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d40d8f88334527f20d5a89dc60f49d37d85752ca5cdf0883bcac38706a9573f8"
    sha256 cellar: :any,                 arm64_linux:       "849ff608b2f31bbc872e8f5204408688686befa41d39d7e43b06f933b3df45c1"
    sha256 cellar: :any,                 x86_64_linux:      "941de024f76a9c39cb2f8f72fe400e5f2ef9eb736c83b6f2093e5a9aa21d05e5"
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
