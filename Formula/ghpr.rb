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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55bffe38acfe3fd2641f321ddad2dd6e433168693d9830f156bcc16cbcd055bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2155bb3b297df1515c17fba7f6b24305fd6a70c9e14fbfe84240776ad75486f"
    sha256 cellar: :any_skip_relocation, ventura:       "e892a453b35c9a65fba0c00d198faaab8b9bfdba23c1d3f8b48a08e9830d3c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7195a7874f772f3a6a11bcc42b255d58ee917fb10e8880b8fd4e9aebcd522167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67952ccdf93743518b06c0f121c9727adf6e86d29b5a396f9b534730de94155"
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
