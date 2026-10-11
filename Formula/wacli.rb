class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "112151b6428343ff180856d5687fa39af2c7f652d6f293c6f70356de0121bc9b"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a8762331549455665d12ae4b7179eb2ed81d07a6e49cefba7994bc500597ef2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a4914d1d50c7619914c28ba2f74c882dcc3d70ee6882e5aec9913cf8b9910e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ffb28a4fdc57589a5562c82c5b9b0af0ac151538a9a4f3fee267c828ffed989"
    sha256 cellar: :any,                 arm64_linux:       "41ec09f0a47f4269a7e264c8bde600dfcbd924f3cdfabddb10e0158e21bb4ef1"
    sha256 cellar: :any,                 x86_64_linux:      "db84a486037e264059c4b7285bcc2908c2c67db0dad674a48577eae8a1e62a3d"
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
