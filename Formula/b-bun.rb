class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.4"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_sequoia: "9e548ed8b5d3867ac4fa146c62aee9ebdb0b3afdd3eb39c6dccdb9cec6c67ab8"
    sha256                               arm64_sonoma:  "f2a631572b374397bbeae761b62d8cb9258341c32dd8e5474e46c7dc6f7dfdfc"
    sha256 cellar: :any_skip_relocation, ventura:       "6376e25e984e25497f8063afc0b4c2a10dd8015113fbc9c32ef3ac1b7bc217d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00fa9669661af6d9c188c5d808bb028ad6d45e54ad34d5c9fc66040335ba44e7"
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "fd4702870bbb911836469a703aee7c1c7dbafc7cd8fc580429ba2dda18bb5aa1" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "d2a4ef2cae7f37c16415e7a7668a6e84c15d88b9ce8ffc1fbb44f43f77d30bc9" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "0c432c2e045691e709c18f8c2fe0b4d2d92974ed37f40e4887a666632a295fcc" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "694a1b39ad3560f3fc7c8e0ac42df277d7ac4f28fe373646104000ddff9ae85c" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "8adcbd74cf1af07dc3607ebee32bfe5a53353b1aef9515963781183d5c401586" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "e03eb2559a61af0cfb7acf3e59272d55613ef14078f156f7b22512456caa0f8b" # bun-linux-x64-baseline.zip
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
