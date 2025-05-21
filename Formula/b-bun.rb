class BBun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.2.13"
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
      sha256 "8154367524d8c298edb269b8d0df61d469ec4194d361c07e4b8d2c65fbbc2efb" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "25997191ce4235c9a4f6ff54c9d4774060a66cb330992e936c388ea4b38c7762" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "05387a4645891538a0df7425e8912ec16b7425116cd416766aa52ca3013f8c64" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "b6a25537bc2d11ebe44a478dd62a8e01dbc9f4e1c4b7d2d730b4a7e9d3580cc9" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "8bb2e4c47eae183f2473c55b9bce7798c4a2836d646c2587a7987a3d1062e100" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "9de5b4a6d392c1de6b9c612bf26e9644bbce47ce09f0c847cedf867d1536ad45" # bun-linux-x64-baseline.zip
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
