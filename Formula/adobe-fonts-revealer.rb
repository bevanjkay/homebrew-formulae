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
