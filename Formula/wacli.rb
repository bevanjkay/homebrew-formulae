class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2b7e091570039fa44b3d6ca2205cc89be612a088f1ab654e60667aa40add586e"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecec21598733f3937442dc57ae6e0cea66bb2a4b0f26ef1f5c3261f8537a1d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2272abf27c6e04adee7cb4892b8b19456677d8ea93fc5827145d194481421a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50df1a0f6dc93e858df6f731e7832cfefe91052fee6e29e91d2db132021af906"
    sha256 cellar: :any,                 arm64_linux:   "f14e209b05a550be3ccde0ada0a885bd050737aa3c6b54e6a1d2594f15484224"
    sha256 cellar: :any,                 x86_64_linux:  "46b71388e763ed48f1c416d441ec7d68fb73bfa91c980ac4ab1b50d7c0c2778b"
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
