class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "1199c98bc7e205cf96e88c748ecccc65c16b7812e0f8259908e7ba53a18de0be"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96a3a14903c7410f5e3bc53c78667fca1e3e1b26b4b47e986041d28cd8835ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2be6bc0dd4a6d8cf7e419f408a6ac1afd92bf5f3b933d741bc7d2141fb96194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae702ef43384b8884871990d3e787bd7b271952c68ce4fa28e95822872b9c74"
    sha256 cellar: :any,                 arm64_linux:   "3b11c94388362cdbcd543b6a5c397c8043644bd44af888a31f91df0448ee9ffb"
    sha256 cellar: :any,                 x86_64_linux:  "9bf9797d8e9fcbc7081d046286771dce7d24152183859f0ff96c7913dbf7da6e"
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
