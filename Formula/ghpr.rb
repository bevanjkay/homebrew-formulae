class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/f0ef198c2e464a11b510a8d2a86e23b41b18bcd8.tar.gz"
  version "f0ef198c2e464a11b510a8d2a86e23b41b18bcd8"
  sha256 "31bd63417a04505b796f7f06fa576ac845e749ef2c738a04f17e2636e2c298e3"
  license "MIT"

  livecheck do
    url "https://api.github.com/repos/bevanjkay/custom-scripts/commits?path=ghpr"
    strategy :json do |json|
      json.first["sha"]
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc60b22ace1964a6f86b69f7c11f8615ad3d70aba4e8609a1bb51915674bbc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4efe23d1add56daf9835e1af9404ef0159acc46963c76b27b9d8e900d2b5fb"
    sha256 cellar: :any_skip_relocation, ventura:       "c5df6516d7a2f6200b0cedab5fca700b7427d27fa788c2d37dab717e603fff95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2caede65ec944df3b539f1ba368b6d1e8cd7a1c627dd259040f23e6550de06"
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
