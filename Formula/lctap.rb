class Lctap < Formula
  desc "CLI for bumping tap casks in parallel"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/lctap-1.0.1.tar.gz"
  sha256 "f2ab4f22f9c8fcccde0201cd87a253de28fd7208ae74e2fc3ae09dc20cd719d0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^lctap-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c025a7644124d69f5076bf3b92a3d0d97456a01813df6043c370beb9e354050e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d42646cc9b599b011a545ca4f9df253ab973b2019480751df7a20e99d1c955e"
    sha256 cellar: :any_skip_relocation, ventura:       "0831f895c913b19c9d95a57f20edd45f2ea8401056e04b66b6818ddf0aa2803a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff41bc82dfdb4cf1d7d6c17692fec3415b2f738af2f46036e09e2ab946029767"
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
