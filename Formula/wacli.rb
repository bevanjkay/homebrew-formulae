class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "85b758edf55a6d9d5f2eb63191766ae8af85a85203714127d6e2473fcf11f8cf"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcb7cc2d31990364310878fefbf4e24b979578314d50519fcedb6dc02403781a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "016aec0626c6146ae3b0d22521408256f113e43a720535c87a4214f047fbb836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c1fb7b507be48b574869b49224e931798fe206a9b0a86102a1d0f4b090b5dd8"
    sha256 cellar: :any,                 arm64_linux:       "46a2030dfa5a887a94de511c2780a6950471c5b61e416b60cae6fbe4c85ce8a6"
    sha256 cellar: :any,                 x86_64_linux:      "a52e246b0005c826089d8bffdb1dae6e6e056bfd9a35a5687f727b9bf88d40f7"
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
