class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.2.0.tar.gz"
  sha256 "430716d030f8cb69e598fba7ec9b4e2af838ccd1d77390cf444a77809fb978d8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15e22a7ef8c4026b991c147274fb58158cccf6e07744d31d34793e732746cb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b45452eecc686937b674f9aa087b6cb17fb7818eaf6a5c641d5440e6bd1fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d2e049e62439f733a7cccad35dba157f96a9a3d1f6444cc26f87f998b4907b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dbbdbea17afe604535c77e36988cae2f67fbb7c7cffe80a324c51f9b978bf7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca7d16c4ab9b0609cec1c2ee0cfbe3b2b5a1905328397acfb3226b834e97e0a"
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

    output = shell_output("#{bin}/ghpr 2>&1", 1)
    assert_match "Please enter a type", output

    output = shell_output("#{bin}/ghpr --help")
    assert_match "Automate PR approvals and merges", output
  end
end
