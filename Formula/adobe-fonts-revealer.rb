class AdobeFontsRevealer < Formula
  desc "Copy Adobe Fonts (OTF) to your Downloads directory"
  homepage "https://github.com/kalaschnik/adobe-fonts-revealer"
  url "https://github.com/kalaschnik/adobe-fonts-revealer.git",
      branch:   "main",
      revision: "70364ff58539081f000ded8fa70018628860397d"
  version "20240422-70364ff58539081f000ded8fa70018628860397d"

  livecheck do
    url "https://api.github.com/repos/Kalaschnik/adobe-fonts-revealer/commits/main"
    strategy :json do |json|
      date = DateTime.parse(json["commit"]["committer"]["date"]).strftime("%Y%m%d")
      "#{date}-#{json["sha"]}"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a2506cae464eda509754631bd7a2407b5619f9f84a277a41d654733004987390"
    sha256 cellar: :any_skip_relocation, ventura:      "2725280b5554ce7e721b81635a5dc52833dab9d9cfc4766cf41d14b2eea011d0"
    sha256 cellar: :any_skip_relocation, monterey:     "d949e7a468c2a21e8c34fb5234c1cbfbfd899c6cb7a3f00f768a22eb37754752"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb00af8502b3ede102865da0407a2a3920f67d411f8092625c8fdbe9929fab18"
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
