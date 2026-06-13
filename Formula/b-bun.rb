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
    sha256 arm64_tahoe:   "615751e98e446c56345f9817b8d0adf726193355602afe6786d24b2cc55d2e73"
    sha256 arm64_sequoia: "45a24f6a8554c032e60f347b424366f9a32d99c5a542c23c5736530d54197c9d"
    sha256 arm64_sonoma:  "d0c8143869bcf6f9bd7cb54e1fbe61ac17ae2967a2b3c24d4dd26c972542032b"
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
