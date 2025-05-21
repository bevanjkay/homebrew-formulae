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
    sha256                               arm64_sequoia: "618e8acfd0c96be311a528c22733fe3882b933cfa1138fb69bb7e7c0a663c3b7"
    sha256                               arm64_sonoma:  "0c74bbae9d4fdfb476469ba1360cf2cf0199008a46de1477d5982d7454ff5268"
    sha256 cellar: :any_skip_relocation, ventura:       "a186950422dfa894efb5b22bfa745ce02dae53d645023deb058e1515adddd770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3afd61ab46143fe1d6e1215c1be00722e8d38debb48f9b4d3a76cef0074533d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09271944505f9fb46228adb072ae300ff4b17a63c41814355737f738eab0c1f3"
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
