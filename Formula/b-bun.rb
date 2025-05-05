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
    sha256                               arm64_sequoia: "c8a81b9817a14362e6089b4df29cd9d47608534f42b043c1b40ae1fa0615e20f"
    sha256                               arm64_sonoma:  "213a9371fe98a2070034e34a8374479a90c7b9e05a0d67178c79d3e94f9e2f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "5e661902b6d30daafa42cbefe7dbffd26011f872e740abea8b5bb04250f6c3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017f9c48d94a7f370371d3e598c6b6efb45e3a91ebe7f001ff23dd1ef18d3c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0082f6f44b04a18a91eae07eded56c25ce123366b52f2d8bdb0d9039b7602c"
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
