class Lccasks < Formula
  desc "CLI for bumping tap casks in parallel"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/lccasks-1.0.0.tar.gz"
  sha256 "609df54836d26398e4b275e9f2518d9565e7e0850808b031d27feeeb5eb84c73"
  license "MIT"

  livecheck do
    url :stable
    regex(/^lccasks-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c025a7644124d69f5076bf3b92a3d0d97456a01813df6043c370beb9e354050e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d42646cc9b599b011a545ca4f9df253ab973b2019480751df7a20e99d1c955e"
    sha256 cellar: :any_skip_relocation, ventura:       "0831f895c913b19c9d95a57f20edd45f2ea8401056e04b66b6818ddf0aa2803a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff41bc82dfdb4cf1d7d6c17692fec3415b2f738af2f46036e09e2ab946029767"
  end

  depends_on "parallel"

  def install
    cd("lccasks") do
      bin.install "lccasks.sh" => "lccasks"
    end
  end

  test do
    assert_match "Error: No tap argument provided", shell_output(bin/"lccasks", 1)
  end
end
