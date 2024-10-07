class AdobeFontsRevealer < Formula
  desc "Copy Adobe Fonts (OTF) to your Downloads directory"
  homepage "https://github.com/kalaschnik/adobe-fonts-revealer"
  url "https://github.com/kalaschnik/adobe-fonts-revealer.git",
      branch:   "main",
      revision: "70364ff58539081f000ded8fa70018628860397d"
  version "20240422-70364ff58539081f000ded8fa70018628860397d"
  revision 1

  livecheck do
    url "https://api.github.com/repos/Kalaschnik/adobe-fonts-revealer/commits/main"
    strategy :json do |json|
      date = DateTime.parse(json["commit"]["committer"]["date"]).strftime("%Y%m%d")
      "#{date}-#{json["sha"]}"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e496d58320cdb9ca76d250acc8e87f8b9dd4603ab1feec90885af58fd43202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5bce1a034e8396d8bf23d22034bb05ce8587544c7361c90b73341566c7442cb"
    sha256 cellar: :any_skip_relocation, ventura:       "edd07abfb89bbcdd08b565eaf5fdd0d6d4d9fc96b4b93aa6308bc802256a3ae8"
    sha256 cellar: :any_skip_relocation, monterey:      "4a3bcec8b39de9a8847fc69ff3639c1afa830203df9b7d0fa14dafa688fef58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a262f094308077cd8b455a7f30f450252eda9de01a776d19df519ef1eae532"
  end

  depends_on "lcdf-typetools"

  def install
    bin.install "reveal" => "adobe-fonts-revealer"
  end

  test do
    read, write = IO.pipe
    fork do
      exec bin/"adobe-fonts-revealer", out: write, err: write
    end
    sleep 5

    output = read.gets
    assert_match("Font Revealer for Adobe Creative Cloud", output)
  end
end
