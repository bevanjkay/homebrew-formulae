class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.46.0.tgz"
  sha256 "b5800a3c00e28afd364122786c13d9555e9af1e6eeaa31d62ecfd1486e95e804"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1337010e8f48f5a3124ca76bb0715a6491392889bd1f56fde1220e6cb77756a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d6999c4940f7412bc6f24ae04e82d0f585773abc54e940c6c67fffcf19b5708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfaf0822446425b657f4eb48999908b1f46ac15ad206496523bd7d3ef124723a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a67e70dd56dca1bb7ae98bc899ee0c1aa0bbd7ca30221bb5092112f6b26cebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "77dfcfc645d31701e1284423b79fef0cbe4ff1ba516f58c533b54740eb4d4beb"
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
