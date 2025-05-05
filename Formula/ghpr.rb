class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.1.0.tar.gz"
  sha256 "75d6513c79ac478adbb5197532af0e356b97fafc8d0056ddcb8b97c7c148a87d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91295a6801bc268e3a82441391256d6504f31886798c0ddc2c3c69218972f4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28264a05ad7a32b3a090b2a8827cb541fea18a0dbaebb7cf32993cc82d06fa0b"
    sha256 cellar: :any_skip_relocation, ventura:       "152f6f0a9652f3c7db78eb86743459d69553fd32e6d3c92a84f0e4dda51faf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411cb8b42aeb556afcc1d72d8d5091ad84f25438b5a9f2014faa76bdebae64a3"
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
