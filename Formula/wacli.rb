class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c687220d4eaaecddd5e1516d740ce7d0f5752e5a5e57fc847934877541fdcf6b"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b39b6caccecaf1b57ca66fc87c999d50ca6dc9187cb9db23b3062473895e19b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da73a410009a87088b1c5f147a1e8718b881e179ab1173062f6f97ee74ee46ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c4df69fe309d7c7e98f13b2b90fe3e964243c99700f33c7ec7d280b8383c7d"
    sha256 cellar: :any,                 arm64_linux:   "e308e2deb45953e9a8c4d564edc66f211da868a4fb2c3d4d69f2fe365f8b9399"
    sha256 cellar: :any,                 x86_64_linux:  "1f6d66b567fdbb303c405216cf8cf557b611db8fc809958e271ff23acc78a98c"
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
