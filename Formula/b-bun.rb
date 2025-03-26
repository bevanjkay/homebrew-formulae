class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.6"
  license "MIT"

  livecheck do
    url :stable
    regex(/bun-v?(\d+(?:\.\d+)+)/i)
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
      sha256 "231f819d531e8a39a44b9541a82009a68189c5a42ecf9b2e755030bc8631f02b" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "31dfce17ff8968bad78cdb4d507b5436703e716c5e537d3100c90b523a937b86" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "777909bf1db3e962f034e2222ad553a63c33b3ea35ae4be9839cd87fe084efb3" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "8359fad7149251b8e72f83e5fbd9fca05379df1777e2129afc3912a9e31b2b24" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "cfdeaadce13fe8381ea6214ca7212e8546faf88a26f3edb7c8d6c6a6abc58e1f" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "8519d1a88038c390fb6f562b7df45a9019a6ce3e20d667a9ff8ab8b53f389488" # bun-linux-x64-baseline.zip
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
