class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.43.1.tgz"
  sha256 "a3c6adebe8b973647b6db32467266eb5121a50572580aecddaddf27450f0e366"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c08b094d65d09f6664f08d5a36e5cf4a56f09c78d8d9c9f944f326df48e69a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a72d86c90076e3e48ea7e4a5354083872eae4a1ca65241f44c256ff05822f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b63d279b4ad8cb6d0b9e83154ccd50b2345d03078fb5e8dfd598f36f8bd73b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61933baa9596037a68fc90b96fcb28733a7f46b407245388cc48a94e83ece52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d439589002fa440ace0727fea107a4a57457d0a4b936aba73f37dc0c01104560"
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
