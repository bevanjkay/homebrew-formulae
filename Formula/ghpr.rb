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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb0db8b42f8c7596c1206ce79a2d46108bc7315cfb91a41be2c563c22dcf1fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84437746c60da75d720b5cbaad696c1cdba6664135cef90df2f504fcc53e1f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be32c486a77639835ccc51edf2a7c9f9e29708239cda7fadabf03200f5ab3553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea64882d37a852fafb284cec3d84ab8f23cd33942dae67fa146f5a6e385292c0"
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
