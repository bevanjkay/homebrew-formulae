class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.56.0.tgz"
  sha256 "058cca318279f3992f1cba32754390922cacd7726f02155fc56d08d5a04dbb6c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a81883f80a621e1bbd4f411172dd6448a5925e76c4c7ef739510095fdea2610"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6caff6cb23645625661399b7e3d5414241109520d318919666f122c562e4887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db68c64b9a3602fee7a22b379952eac40e5b2af842227ac83acb342209cb8db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3dfc116d7e9b85313a819f88c4a949a3bcd6ea4ed837d3439fd157137a7a1423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e22a78ee1a2f5230b011e339f7f2d31879edda157c880399453b699a742ee207"
  end

  depends_on "node"

  def install
    system "npm", "install", "--no-deprecation", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")
    assert_match "Not Authenticated", shell_output("#{bin}/surge whoami", 1)
  end
end
