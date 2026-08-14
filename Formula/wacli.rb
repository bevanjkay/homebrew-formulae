class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "cecdd92bfcc7c1979ed2bdd2a8a8036a2f0d60c7813906168a94a1aebaea6824"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e015af20c0473d2f79e9e030c93a07c5af32f87eaf472e4724e7e124d7b6d62e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2abab6481450bfa55a4304c9265dc4000dc0e7c52063736a950b07b8c066f336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df0a5fb762a5d518152d18864b0f7e974ce491186ca2f129385ea7908dc4c5e"
    sha256 cellar: :any,                 arm64_linux:   "39b54af913f907659a937c139e0db60b6b5263eb3f2a39ec688ee3e76565ea64"
    sha256 cellar: :any,                 x86_64_linux:  "95af3205f673abce3d2fc9b4fc2dbcbfe2d1694339c760231b64cd9615cac4b1"
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
