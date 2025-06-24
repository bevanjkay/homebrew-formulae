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
    sha256                               arm64_sequoia: "d17126f0ee0da4f3fc76c17687228b11e3e6d9bfd4613eb8b14a14054cfc981f"
    sha256                               arm64_sonoma:  "b941e1a05ca01cb973e4fad57c9525b037e363c5aa3dc763f832000ebd9e979b"
    sha256 cellar: :any_skip_relocation, ventura:       "2e8c3180b724df02d028b0ec689b27d8cedf71397fcd577beef1bdaa0db525d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75eb35ddfc851c8a05d3b96ed13761cf3b75c9008dc8c6b8fc15926e09a0fa6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7956a8a202fcac3666867cd5a779ad0035cb9995d0823b31639d9dc97a49347b"
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
