class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.3.14"
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
      sha256 "d8b96221828ad6f97ac7ac0ab7e95872341af763001e8803e8267652c2652620" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "4183df3374623e5bab315c547cfa0974533cd457d86b73b639f7a87974cd6633" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "3e35ad6f53971a9834bf9e6786e2adf72b5f1921cc9a9c5fde073d2972944076" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "a27ffb63a8310375836e0d6f668ae17fa8d8d18b88c37c821c65331973a19a3b" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "951ee2aee855f08595aeec6225226a298d3fea83a3dcd6465c09cbccdf7e848f" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "a063908ae08b7852ca10939bbdc6ceed3ddabce8fb9402dce83d65d73b36e6c7" # bun-linux-x64-baseline.zip
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
