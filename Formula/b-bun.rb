class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.12"
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
      sha256 "89b53f6db754d324cd689cfde5d035cc124c90344423c5d6bc07f8f0094fc7a9" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "1241d73c1275d03aea6582924cb8063d847862c167bdfaeb7738bcd1d8350a55" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "61ed0eafbbc3406440a78b7403ab7c0788e0926ad1d98ec28c332332f5bb6eee" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "c898a2057f919b700bf289d843dae49ee114c8f625c7c1fed043790f54694509" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "3337964faa31d8bce199f91708130710ef2e70b98ff34a34f590b1745880a633" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "f087bed0e61d351dedae2fe38c760f98d531ac66205225c8cc2095094001a56e" # bun-linux-x64-baseline.zip
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
