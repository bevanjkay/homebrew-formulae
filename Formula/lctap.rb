class Lctap < Formula
  desc "CLI for bumping tap casks in parallel"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/lctap-1.0.3.tar.gz"
  sha256 "23d90990b397d9e6ad193fb6269b424f27ace44d8028d6b752c304c03933a21b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^lctap-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca6696687c24f138540014e8bcf45a4d2bbf97c3579a251e16c08133fdd87dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c29ef6fa2620c8686f5f1ca4eb9bd64bfe9e6a4300279c9f3fdbf171691cd48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f84a7f28670d7497f6bd3fa62b45d4254665b1d869ca4e08b28141acbcd09bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb3b8db60521f034131479fc1f11f6cb8f1e1982461157602f55823cfdc4c919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62de6d6110ec9b52507e0d80eca4e962a7ce51af101937c9390e0966a014b99"
  end

  depends_on "jq"
  depends_on "parallel"

  def install
    cd("lctap") do
      bin.install "lctap.sh" => "lctap"
    end
  end

  test do
    assert_match "Error: No tap argument provided", shell_output(bin/"lctap", 1)
  end
end
