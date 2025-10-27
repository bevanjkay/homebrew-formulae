class KillContactsd < Formula
  desc "Kill MacOS contactsd when it's using insane amounts of CPU"
  homepage "https://github.com/SteveC/kill_contactsd"
  url "https://github.com/SteveC/kill_contactsd.git",
    branch:  "main",
    revisio: "5a3076ddd01d2659b51bff304f2afacc9caf6221"
  version "20250411-5a3076ddd01d2659b51bff304f2afacc9caf6221"
  sha256 "b0a8c55c9557254a073db9323e746f37825b75381d8b0c17a1a452c636e1607e"

  livecheck do
    url "https://api.github.com/repos/SteveC/kill_contactsd/commits/main"
    strategy :json do |json|
      date = DateTime.parse(json["commit"]["committer"]["date"]).strftime("%Y%m%d")
      "#{date}-#{json["sha"]}"
    end
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
    assert_path_exists? bin/"kill_contactsd"
  end
end
