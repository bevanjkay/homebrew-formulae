class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c2a7a3a52c7c30b8e40dc82db5d67eb29525b72cc960b8e14bd07972247b5300"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23855e7d5f8b8b1963d13a4e64e1f0d398901a32ca21ca28c8caf713f2c1d9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b60a37cbf45701fb346bb9c056fb83d97e966446438b8cf75245f30c61ff1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1bd2d45583989d81ae086f76fbb1c3fdae35f6b8e1ba6258a62d2dba36b76ae"
    sha256 cellar: :any,                 arm64_linux:   "f5acf63b3598265697216eb3e027dd5effa0f562e21b3fcaaf38941c4c883c6a"
    sha256 cellar: :any,                 x86_64_linux:  "9b7a2f0e1414754a7f28398e78a399025d06748bdf433052389e42654236a153"
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
