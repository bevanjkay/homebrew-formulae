class Macicon < Formula
  desc "Fast macOS-styled app icon generator"
  homepage "https://github.com/Qrivi/macicon"
  url "https://github.com/Qrivi/macicon/archive/refs/tags/1.0.1.tar.gz"
  sha256 "055b76ade0cfa8d898a2cf59f3cc2904b4640e67f35e8151f7b724b524a71a15"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256                               arm64_sequoia: "2789b355bcb0bccd12ce0c1c946abeed7486fdb3367e8adc3d48b337557cb3f0"
    sha256                               arm64_sonoma:  "ee2dbe1fe19cb58fce45632d8ad0b5cec1129d51848fb372554ea9aec0af4d1d"
    sha256 cellar: :any_skip_relocation, ventura:       "34e99d1b83f365ca80b6f8860a72129d76efea5ce32db935b9017401085ba33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c66f429d08fc57f827cbd6a6afd5256c420273482e5808f79c51c8075f3f3dd"
  end

  depends_on "bevanjkay/formulae/b-bun" => :build

  def install
    system "bun", "install"
    system "bun", "build", "./src/cli.ts", "--compile", "--minify"
    bin.install "cli" => "macicon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macicon --version")
  end
end
