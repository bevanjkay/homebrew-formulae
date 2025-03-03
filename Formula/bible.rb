class Bible < Formula
  desc "CLI for YouVersion Suggest API"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/1e43e8e40cdac4734747362a34fce46f2e151579.tar.gz"
  version "1e43e8e40cdac4734747362a34fce46f2e151579"
  sha256 "a5883d523dbdb805339a3ce9684ffc5ff68a831e03d96e0c79ce08121def6663"
  license "MIT"

  livecheck do
    url "https://api.github.com/repos/bevanjkay/custom-scripts/commits?path=bible"
    strategy :json do |json|
      json.first["sha"]
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314c57bebf33f2717b07e2d14c89a01f6c02c8c262a6f6440764cb05a6aa66e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512cf20635bb793ce9fd22a4f1bda0b5c7fbb5fb568a3d4119a57e6b588e705e"
    sha256 cellar: :any_skip_relocation, ventura:       "008c44f01e567d249110c92046bc478b128fea2be57bb720b7cccbb68cb76fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d383a9a70b6a9058503522e0780cd0fa7c89375640ddc727c5be5d4a801811c6"
  end

  depends_on "deno" => :build

  def install
    cd("bible") do
      system "deno", "install"
      system "deno", "run", "build"
      bin.install "bible"
    end
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output(bin/"bible john 3:16")
    assert_match("For this is how God loved the world", output)
  end
end
