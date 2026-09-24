class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b7ad4f58fc9c09e34f0888f654aa704361c6509b57cbff300459974b859f6ae5"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8cc2e59ecd7a55c96c5e38e48587431092290351cfe595762c4f35a3902d80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4702f5b24710bcf865529f59d77fa7970e1885dab3efd60e386515ed3a3c32ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0123805f0cb85489df323f816bcb0c72c0085941b19f401f12a6af04fbed8d15"
    sha256 cellar: :any,                 arm64_linux:   "96feeb9c288c0cd6d18773d723b1fbf41df885b5d4ac1334038e7b718451d2d6"
    sha256 cellar: :any,                 x86_64_linux:  "fad24b334a563072c8b75ddeaa4f98da041a45361842b2f0f0636a87df9a6714"
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
