class Tvmv < Formula
  desc "Bulk-rename TV episode files with minimal fuss"
  homepage "https://github.com/keithfancher/tvmv"
  url "https://github.com/keithfancher/tvmv/archive/refs/tags/0.6.0.tar.gz"
  sha256 "c5fdfdf3da415ddeb1b60da112b6d80c677d42390a93b3185ecfc73536bfee33"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f21f66a2c2f88dc9038667d2ecca5dd99bb9ed0cf6d71456c99cb14aabfac32a"
    sha256 cellar: :any_skip_relocation, ventura:      "828e91e57ffd50b0ed47a9839711384a3ebd15f5610330a8b702c2bc91b8450e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9b15fbcb6f6b16756ae37366d4893b7556a5b76971a145604cc8a0f395464f4f"
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
