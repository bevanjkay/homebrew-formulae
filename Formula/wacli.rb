class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8f13537b24f78a18c87e494e743f5c80d22546b5df6626de07de4d523342c7a2"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df02f634bbbfadaca1de7192839fa43109c06cd69261c81cced7096c0cf35f69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c72615fec0c829b39af0c864986485046de7a8744649724c76ef4dc5d517523a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe97e4fe29d4bba94167c40a2cd66970509359b8c67a6e5cb7c11d6c16b21cca"
    sha256 cellar: :any,                 arm64_linux:       "b9a975323bf7c6d1ec288341853482fe82dfe2cc4fc12971a9c583c0c0d30fdd"
    sha256 cellar: :any,                 x86_64_linux:      "4ad0151d82ac8344043473fa17bb6da6b78666d026b507717bdf95bf65c9bf8e"
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
