class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.40.1.tgz"
  sha256 "60794ac02d7689b99a992aa5f3e68e7479db36217dda77a9cde873eb3c08f3a1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a662493141cbcf98ea0c3755ec23cd29b4eaea892e7e5967d832e43bb1c5721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e2c9a56a66ca6492cd084daf0d33e2b01e7c2933956c22169219183d0ccf4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd013d5b40c4d977e9525aa3b680cb22fe11c761a4f3909a019d5ead804deb0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957f2ef810382a31c3df46cd82e91a39b63acedd925e26298e81b18c253e3148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd006859924b20c99f8571a47f816c8583de0705b73a88a10685e08dcef176c4"
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
