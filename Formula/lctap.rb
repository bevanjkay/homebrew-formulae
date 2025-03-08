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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a093fde6309b7385dcaa30b97db41a783c4d865ddabb4b30bc4739afbf3d885b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40dfc0bc0d1b07e473490be3c00ca5175906181c765b798d00d4919c8fcf7e8e"
    sha256 cellar: :any_skip_relocation, ventura:       "93f6eb5fccabb7944ff8c1624477938ca310ee96fdad406df234d2c92fdad7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3e0f05fb2fd7d8c7087d61dd656d1303ea419a188bdf9edbe66132323d4eed"
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
