class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c687220d4eaaecddd5e1516d740ce7d0f5752e5a5e57fc847934877541fdcf6b"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec86c8d6537069f33ad90965dfb66883ac0bb17bd03502a8389810724657960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b35b8226364ac1e1781640a9675692ee1ccc39bd7f62152dd59426c11a8692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87126e9e08d6fa582fe38d9566855a9c83dd082b0abc8fed917437cc66bba051"
    sha256 cellar: :any,                 arm64_linux:   "4c368c9aa50f6757512af3c0e01e43752f873dcc1af163b9321ab6ecb43f266e"
    sha256 cellar: :any,                 x86_64_linux:  "38d41ca26a9282b99cc6bdea4a56da33517de918a25fc852720b76ef3a28b28d"
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
