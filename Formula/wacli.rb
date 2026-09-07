class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "2215899c21cf84cbcf3eb525464eeafc8554b5e3fc839288bf879854776c0565"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1519e817d7b15daaced4bc88a840dbf6e90743d3e1b71c545a3d2a1a8c95524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb084deead16fccc7234c9712b0ab26a03759102dfea0a2073ab2f5230cc643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de407a7d19cd4a592ebaaf58e71e9ea97be9549822000d728ac631eed7243866"
    sha256 cellar: :any,                 arm64_linux:   "3e8050de41fb055f40f958145cc9e351f1d81106b60fbb0f2fd1e67c08967045"
    sha256 cellar: :any,                 x86_64_linux:  "6b7a914b87b910196102b7cbb5c47cbcb194c2ecc1b74d9510fb04fe6537f49e"
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
