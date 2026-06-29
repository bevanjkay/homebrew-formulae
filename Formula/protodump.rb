class Protodump < Formula
  desc "Dump all Protobuf file descriptors from a given binary as .proto files"
  homepage "https://github.com/arkadiyt/protodump"
  url "https://github.com/arkadiyt/protodump/archive/3bb63dd0710124b4393d9f2fce22dcc53d230f79.tar.gz"
  version "2026.06.27"
  sha256 "b86cad278b53de238a55db51a4555cedde40740bcc4ae20f86d1b7eee54ae353"
  head "https://github.com/arkadiyt/protodump.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protodump"
  end

  test do
    output = shell_output("#{bin}/protodump 2>&1")
    assert_match "The file to extract definitions from", output
  end
end
