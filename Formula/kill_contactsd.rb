class KillContactsd < Formula
  desc "Kill MacOS contactsd when it's using insane amounts of CPU"
  homepage "https://github.com/SteveC/kill_contactsd"
  url "https://github.com/SteveC/kill_contactsd.git",
      branch:   "main",
      revision: "bc2705dc3088cf6547c9d1830a6bda98df15ac69"
  version "20251112-bc2705dc3088cf6547c9d1830a6bda98df15ac69"

  livecheck do
    url "https://api.github.com/repos/SteveC/kill_contactsd/commits/main"
    strategy :json do |json|
      date = DateTime.parse(json["commit"]["committer"]["date"]).strftime("%Y%m%d")
      "#{date}-#{json["sha"]}"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b651b0157f13682eaa9057e0f888783568ebd386f6cafbf6970490804a26d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae97055adeb60e8b2eb01f9e374cc920c5d815aea0d5bf3dab2b3ce7043eee02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5853ebab12aa220e8b02a5f4e297ac68042cf01e2f314eb1ee99687fcacc082e"
  end

  depends_on :macos

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
