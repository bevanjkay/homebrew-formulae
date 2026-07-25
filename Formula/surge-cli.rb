class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.34.0.tgz"
  sha256 "684fbc439bba30469e543dfb29835e0061f129ea851636c38ec0b9bbd0b38f99"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c48419e95d96e6368bbbd8f3b418bdcef710a5af848023492c9831dd262204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06f5f5db3a2154f794579a5bfcf91bf3b63e038dbb0c4a0ba269b15fb6f71dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0346c35d5441d8fc983d4866b89a8097fe8646f202df0256284d13dbbde1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfb92cdd3c08c8d8ba712d09b293d361bcefd5cd29915ef4403a40bc0118a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eb2cdfe3b4fb8484dcb78854e4a4bcf55cbf34fd3398ec895c2d350e5b68873"
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
