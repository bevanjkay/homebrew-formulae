class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.15"
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
      sha256 "ab0cd6fc7fc8d1ee4f8166d99b71086d4793c5aee0d0b5c73fdf9b70fa47ded4" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "a4d26f5f3c9e066493d7402d45a201defcde8f8f415cc1b54fb874d02d15940f" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "60b324330bb141a87a078ad01baa3f0b8ccfc2896fdcc72c005ab54a79099935" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "3c3d006148f37200f967fd8070eefb340468287bacb44524a31cad1ee9d3bb7b" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "a261626367835bb3754a01ae07f884484ed17b0886b01e417b799591fa4d7901" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "386ca291c7fa98720d0e94daa1133af811e69fa24352558a403c1b9759e7eb98" # bun-linux-x64-baseline.zip
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
