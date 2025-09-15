class Lctap < Formula
  desc "CLI for bumping tap casks in parallel"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/lctap-1.0.2.tar.gz"
  sha256 "4ae75b676bac25380bb9a296328401666915786867cebba7935ad5b5be3654d5"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^lctap-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bd54dd8e733896371995361e2154d43d3e724f220ad54504853f7074f84d4d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3cb8a4889e832227c6d936683de9edd48e6128645b57dce83766c751df4df04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302350de47bb3fa544b88e14563c18493102acba39f3e60fd42aee0ab442ddb2"
    sha256 cellar: :any_skip_relocation, ventura:       "c862002fd4308f628117fb209fec678923251fbfccb0035cd364ca337d214fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe742613d879606fb8c201742f05f6f01d69a447baf827e06819f662d71010e2"
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
