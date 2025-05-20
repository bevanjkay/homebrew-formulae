class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.1.1.tar.gz"
  sha256 "d36b27c8c4f26c4079013e3c12179b6b63a9ac103a64ee82ad0e5f39399c03a1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992f27303cc3d5b11b07487f946125791a0a96b6c1693f071599f1b94777d824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba89bdc69ae64be7fe3f4c9c6b85232fa4d98ed90b8dc519dbab4867c429120"
    sha256 cellar: :any_skip_relocation, ventura:       "7bb5442bba5e924735a1e4e7ee51e79a1f84982f95f9d6c71b693e7209eb1485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb2f41cc5ecd8bcf1417db05b60b5ce1563df6d379e49b572c83641727f7b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a02e7b9df91ebcf8ddb5ca202f39a9e788967f91991cc671e5f126412817ca"
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
