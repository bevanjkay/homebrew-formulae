class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.43.1.tgz"
  sha256 "a3c6adebe8b973647b6db32467266eb5121a50572580aecddaddf27450f0e366"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f23c6a89e56945fc34db57076fb95b5530bd3fe661653699cb4da7221b96b06e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f859fb419759efbb39037bc6de32ceb1df4e8edb25138eb0150173a9c699d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c93249b53ebaf82b00fddc80c79ef62ff79835ef0fdfac8fdd695e80e0eb26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5aa6edca5563c63072e5e1f52cfad30f1626241065b381ee71753c0a68d42e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17af52959ef21acd8644efda3cf52aee7f305af0d61cd694f6e49f5002854fed"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami")
  end
end
