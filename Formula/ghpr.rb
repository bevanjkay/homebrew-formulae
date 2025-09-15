class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.1.3.tar.gz"
  sha256 "30f32f23ca9c62c0abac8547b714d9e06bff7062a756f456d8c9331dfd79b6ba"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106c25c5a4f3a23fe23420d94a90a261b0c910db0cc70283484bd213874dd1f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f6ecee08f5d65c51e013562c74fcb6dafa3816b4f0b0ec9b8f3ac88252a472"
    sha256 cellar: :any_skip_relocation, ventura:       "4786d286d8db373aeb4f1684e38a5e2978d1e26a32f8c80cc8e13c3b1e389e30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3941a1ed9d9213a2253f809a609779a8fa4a7c2876dd8b818dda3e81888447e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa255c373cd83e0ab697d0a8a09add5cb478f7fdd8ac38d2663ba31babdcb10"
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
