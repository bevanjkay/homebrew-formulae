class Tvmv < Formula
  desc "Bulk-rename TV episode files with minimal fuss"
  homepage "https://github.com/keithfancher/tvmv"
  url "https://github.com/keithfancher/tvmv/archive/refs/tags/0.5.0.tar.gz"
  sha256 "5c668cef09a24bc2952fa2ec877a95016090b728c6f379f3a3b6f904dd275bc5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4f673115552161ae89c0d8c20ed4e865ec8da2bf404cfbdd52f7030bc5686cc3"
    sha256 cellar: :any_skip_relocation, ventura:      "4043c32383a6cb71fde7435da28a71db07038ff1789dcea60322740712d6f8da"
    sha256 cellar: :any_skip_relocation, monterey:     "3568ef6564986f31d22c751c76ec4e350862ca7a7fbb3ecc5343ae2f80746fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b7d13ea335650f67ef53579a59d13d25578dfdca5a02822fb81f578b6336e21"
  end

  depends_on "ghc@9.4" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "zlib"

  def install
    stack_args = %w[
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
    ]

    system "stack", "build", *stack_args
    system "stack", "install", *stack_args, "--local-bin-path=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tvmv -h")
  end
end
