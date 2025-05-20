class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.1.3.tar.gz"
  sha256 "30f32f23ca9c62c0abac8547b714d9e06bff7062a756f456d8c9331dfd79b6ba"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41839f865e0b4c6586f2f2f441d8ce9a84174a0546dfaafb97d59dd59dcf3632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f557ac111388b1e868f3d48c3fc9b915ebab7ac757622e94273c29511baf18b"
    sha256 cellar: :any_skip_relocation, ventura:       "d4d0bec72061bb9ea340a33a6a99fc60550b0bf2e6c7c80e42cdf20b9ca99cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "590871b25e973521853ac061bbe5d044cf7b238f29ca5af89177266622aca4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244de26f17a97a763d25ea3fdb1c5c00fe0cc6d3bcb89c377031798fad560425"
  end

  depends_on "deno" => :build

  def install
    cd("ghpr") do
      system "deno", "install"
      system "deno", "run", "build"
      bin.install "ghpr"
    end
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output(bin/"ghpr 2>&1", 1)
    assert_match "GITHUB_TOKEN environment variable is required", output

    ENV["GITHUB_TOKEN"] = "test"
    output = shell_output(bin/"ghpr --help")
    assert_match "Automate PR approvals and merges", output
  end
end
