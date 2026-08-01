class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.40.2.tgz"
  sha256 "fd8f6ff6e9bbc1eb7e0a32fbdddce0b876ad1896234fa62169590957c768dda4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff9708384afed26184e8e23a2d12dde32152f202c728fb9da1850744f0940c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b26d8693f804a422607ad34cb15853b863b6b783be79fb183f9a0d91aac54fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "201fa632a2528cbab6674f14aef3c0e6376aa615fcd1a84443dcc4df49720f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f26afafba53f3c2c6780a8a366a5b673e73f2e7c747e5944678c478a00ef6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa8ff0d22408c79ed23a4246d50053c8d6a4b870a6a4259d2de38d7c8d974b97"
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
