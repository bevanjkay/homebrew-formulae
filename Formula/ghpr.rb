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
