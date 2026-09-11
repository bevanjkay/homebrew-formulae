class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "b01b9485d7ceb57fe9183d8ad57fab99bf509b904375c3a33a52a69fd2816971"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da2d177735ede875979f89e26ef1e21c0c35ecd75314d17acb9f6b6b6469b856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d093c45347d20f5a4ae99557f0df66a5f169ced6cfaaa4103ea61ac1280b5b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68ea9ce8a0d64eeb0d3f50feda3e3ffb9068d62f34699cb60bdb9e0dd10e093"
    sha256 cellar: :any,                 arm64_linux:   "37399c035d0c2bb2357c990f320967a22c40ea8c0810c4a807d8c542ddae9b9c"
    sha256 cellar: :any,                 x86_64_linux:  "cf9b994b303dc622b47cbb8cbf2348d7d77714a444c4e9ce7ce4b526b86f4fa5"
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
