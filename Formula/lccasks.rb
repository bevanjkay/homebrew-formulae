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
