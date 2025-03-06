class Macicon < Formula
  desc "Fast macOS-styled app icon generator"
  homepage "https://github.com/Qrivi/macicon"
  url "https://github.com/Qrivi/macicon/archive/refs/tags/1.0.1.tar.gz"
  sha256 "055b76ade0cfa8d898a2cf59f3cc2904b4640e67f35e8151f7b724b524a71a15"
  license "MIT"

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
