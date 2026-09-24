class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b7ad4f58fc9c09e34f0888f654aa704361c6509b57cbff300459974b859f6ae5"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "491fa3a95607d78caa886560bba03041fe0c0bb714b8acaadffb894545cd9d27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c58f027015eb94eb10e6dea0460cbed92be06d8d01ecd767120b6be14582d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d00751e13ffb4625761739e059afb15b5e023b98d6bd2924b3aaf7549078950"
    sha256 cellar: :any,                 arm64_linux:   "6f008abde6cf1b3213129334fb65b183516a4baeb31803d2d60391f867931637"
    sha256 cellar: :any,                 x86_64_linux:  "c30c90ff913d4631b211ef89f8b408ac7cdf21d185dd3b800eabc29dd8e5d90f"
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
