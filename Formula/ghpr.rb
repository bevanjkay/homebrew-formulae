class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.3.1.tar.gz"
  sha256 "fa8bca2f021ef694f23881451e165428d16648bf71e35525ad630fa70da83eea"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a8fbf4e193fed16f7d8f03165ace2e3e3bf9dd4c77b683e073d8218cb9c53fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93bd314461c3e5cc5a2ecef5bcb7b6ddd034e375b287d0ac5f9204ccd4a79c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3d7aa42ff67975c49d0ab4e3d0506e3b7c50c7fff75248d02a93712faa1d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2ed185bafddfa4e14cdf51d4634cbad109cf5a1ff066d554a13e37d964a8fa"
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

    output = shell_output("#{bin}/ghpr 2>&1", 2)
    assert_match "Missing required option", output

    output = shell_output("#{bin}/ghpr --help")
    assert_match "Automate PR approvals and merges", output
  end
end
