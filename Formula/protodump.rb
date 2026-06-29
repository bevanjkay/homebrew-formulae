class Protodump < Formula
  desc "Dump all Protobuf file descriptors from a given binary as .proto files"
  homepage "https://github.com/arkadiyt/protodump"
  url "https://github.com/arkadiyt/protodump/archive/3bb63dd0710124b4393d9f2fce22dcc53d230f79.tar.gz"
  version "2026.06.27"
  sha256 "b86cad278b53de238a55db51a4555cedde40740bcc4ae20f86d1b7eee54ae353"
  head "https://github.com/arkadiyt/protodump.git", branch: "main"

  livecheck do
    url "https://api.github.com/repos/arkadiyt/protodump/commits/main"
    strategy :json do |json|
      json.dig("commit", "committer", "date")&.then { |d| d[0, 10].tr("-", ".") }
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e8fbae55764a9ee1fbf433e84bd5748885929b24167ad71f70fff7214ca64c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a2536223ba7fb6143bfd320d5ccb042a1e1815b43b2a2a521b935ba076f1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64bb17aefc1126a1a281ca1f080b6d434d0a6dae8a66c9dbaf9d990f17e7a4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba27a191f74802333971b674f9cd94d2cc2f7feb9e140199612a7edffdb21e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10f75d92b20da18b1d6584954f5f9b9a32fa45eef18eba8eda8828719509b3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protodump"
  end

  test do
    output = shell_output("#{bin}/protodump 2>&1")
    assert_match "The file to extract definitions from", output
  end
end
