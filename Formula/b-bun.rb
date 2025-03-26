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
    sha256                               arm64_sequoia: "e84885627ba232a0e44b7ae2b4d938aa63c226dd1e17eb4f8b1b806d9ce8c9e3"
    sha256                               arm64_sonoma:  "de9babab738f3411fee982c8e604c726af0f18c7a76afab646c03603c5249e86"
    sha256 cellar: :any_skip_relocation, ventura:       "5e73c41ba78795435c412c6d895888920500c600cdfac05a5ec9f04f97488eb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1553febbd301525185fb5577086318bd82b6988605976c7ff7f3bec85a37bc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf86b920b7a56595c088d2561a0a072582d156a18bf34aa585d139f4db4ef579"
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
