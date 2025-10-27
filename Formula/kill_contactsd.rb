class KillContactsd < Formula
  desc "Kill MacOS contactsd when it's using insane amounts of CPU"
  homepage "https://github.com/SteveC/kill_contactsd"
  url "https://github.com/SteveC/kill_contactsd.git",
      branch:   "main",
      revision: "5a3076ddd01d2659b51bff304f2afacc9caf6221"
  version "20250411-5a3076ddd01d2659b51bff304f2afacc9caf6221"

  livecheck do
    url "https://api.github.com/repos/SteveC/kill_contactsd/commits/main"
    strategy :json do |json|
      date = DateTime.parse(json["commit"]["committer"]["date"]).strftime("%Y%m%d")
      "#{date}-#{json["sha"]}"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a7a53ffe4238f8d8c389cbf039c224946259f7b018d58e38b847ea0a9bf5961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a30be4ad614895a6504727cf3ae82c96194e928191b44cb2a767729ee3c61ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17b1322a20e49633cc8e14c9051ebeb889646b987edfd0b08a86f9178fd54f8"
  end

  depends_on :macos

  patch do
    url "https://github.com/bevanjkay/kill_contactsd/commit/90ac583f38fa58f1f17068ea23d21e154451a61b.patch?full_index=1"
    sha256 "a4b2560a4f1a4d2572a01459bf17ef55a59d6be01bcd24ac852c774c2addbc56"
  end

  def install
    bin.install "kill_contactsd.sh" => "kill_contactsd"
  end

  service do
    run [opt_bin/"kill_contactsd"]
    keep_alive true
    log_path var/"log/kill_contactsd.log"
    error_log_path var/"log/kill_contactsd.log"
  end

  test do
    assert_path_exists bin/"kill_contactsd"
  end
end
