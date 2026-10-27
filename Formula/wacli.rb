class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "23d65dcd6d66f30dbb1e8a94c6a0e22fa0ae266a6bbd8ba5d2a619a6ff734191"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29e6f54a5a9151b2de63cdb8b7bcd5351f7b88d66453d35f21ff597a7a217397"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fadbbe8f14950835e1ed9d89d388125fbc1734a4bea5d805ff0bec367a2bff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf4f2c3c98c9ff9929cc4c42a7e7793865aabd4fe5e6452652b328cb249572e0"
    sha256 cellar: :any,                 arm64_linux:       "2e81b8dc6f25584f890c44669730194680fa49718a83cdfad3d9cc45d4f60e17"
    sha256 cellar: :any,                 x86_64_linux:      "0891f801c14433e4b25479e39d0f48ea4b9548482e42f0bc3fee6dd97d664e17"
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
