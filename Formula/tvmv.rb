class Tvmv < Formula
  desc "Bulk-rename TV episode files with minimal fuss"
  homepage "https://github.com/keithfancher/tvmv"
  url "https://github.com/keithfancher/tvmv/archive/refs/tags/0.6.0.tar.gz"
  sha256 "c5fdfdf3da415ddeb1b60da112b6d80c677d42390a93b3185ecfc73536bfee33"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2e8215cfe47795bf8e892558f9cba37769ccf4dfdbd452c007cc44aa200df3aa"
    sha256 cellar: :any_skip_relocation, ventura:      "e0a9645bfb6f5e72ad88a3485eb6cc13469164a08423718824828f0ee7796cc4"
    sha256 cellar: :any_skip_relocation, monterey:     "6559400e21c22b81dc5d7343c819ef14d8ab51c8bfd700d7996b7e1ff15d10f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "efc72d54593246934cc470e6aad0873c58a9cbe6767e6049662a4a385bd635b1"
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
