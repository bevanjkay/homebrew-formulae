class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.17"
  license "MIT"

  livecheck do
    url :stable
    regex(/bun-v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_sequoia: "ae7bf2b3938d21a5a629de0d289849b5f112f49739d46784c06623c09b6089e4"
    sha256                               arm64_sonoma:  "e5e0e154bfd7fda29645e902f4baab44bfe71b078923cce72f4f4b6dd4d24c72"
    sha256 cellar: :any_skip_relocation, ventura:       "b5f432845b8aa75e1479f121b6972faa482086649f232a9d803e6b6ee1efd65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58668e1fce1c14424b834d5fa554d904d25e51c58f7cf335b98a2e0f97f0fbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa73087c38ce828890f3cbb2a6968e443a138cd20adc1d3a71623f31bdc20785"
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "9f55fd213f2f768d02eb5b9885aaa44b1e1307a680c18622b57095302a931af9" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "038023b8dbdccc93383398a0c1be2ca82716649479cfae708b533ca7a9c5d083" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "a54b6a1778a522d8f8cf57c18095aca7642b009cf81613e48805fd82954fb0c1" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "a0b996f48c977beb4e87b09a471ded7e63ee5c2fb4b72790c7ab4badbc147d6b" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "6054207074653b4dbc2320d5a61e664e4b6f42379efc18d6181bffcc07a43193" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "6ea1861db6a6cd44d1c8b4bafb22006f4ae49f6a2d077623bf3f456ada026d67" # bun-linux-x64-baseline.zip
    end
  else
    odie "Unsupported platform. Please submit a bug report here: https://bun.sh/issues\n#{OS.report}"
  end

  # TODO: to become an official formula we need to build from source
  def install
    bin.install "bun"
    ENV["BUN_INSTALL"] = bin.to_s
    generate_completions_from_executable(bin/"bun", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun -v")
  end
end
