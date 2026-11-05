class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "7f431b3ef6a33a2a384cf1c85d12a4e2b62f698be2d5a2dc51519a34faccc64e"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "119d1e936f529eaa5ba1ab7ce7108cfddbe6afafb0d0694647d11171804a305d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63958e9c0afe2ab2a4181754773c518a28cd882faf8fbc43cb44e0a072d30b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4144a981464bb427565513f4851099319d5846ef84f6bb7c30ef2d12f6b10309"
    sha256 cellar: :any,                 arm64_linux:       "845f75774c8e6b5a843cc2429e52a4bdfc4173048f7e398cee806efdc7db9e1d"
    sha256 cellar: :any,                 x86_64_linux:      "bae34f1e4fcb8fe41ef9c52b531956b679d56f95876bba1f9e5c865906e6adb1"
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
