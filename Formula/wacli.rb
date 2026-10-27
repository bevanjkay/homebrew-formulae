class Wacli < Formula
  desc "WhatsApp CLI built on whatsmeow"
  homepage "https://github.com/openclaw/wacli"
  url "https://github.com/openclaw/wacli/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "23d65dcd6d66f30dbb1e8a94c6a0e22fa0ae266a6bbd8ba5d2a619a6ff734191"
  license "MIT"
  head "https://github.com/openclaw/wacli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19afe9013c99996036758f7aedf035372bd894012c59be797664ff9883348dde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ffbd96a37d5c56a09b6aae24fef225f19ceb3df9a5f6c5c36f3083ef02b4efd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "baf2a2232e69a833086efa12df95ee6a814bdce1ffd7a2e4168a5116e327fb85"
    sha256 cellar: :any,                 arm64_linux:       "151f3d7849ba9a43e99b9ff744c5b48990b0599ffa3f177ccf86c6e21f38f9af"
    sha256 cellar: :any,                 x86_64_linux:      "c7997d177f6e8d5b71381360447c20752e2ad74198ac2c4f35b42db19154ab8f"
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
