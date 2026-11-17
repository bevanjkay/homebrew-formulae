class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.57.1.tgz"
  sha256 "8d02a5a27536faa1d0bf771c3efbb3fe08f101209dc4dea72f741759e0f018c3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "334c89fbc11e02d0e75dfbd6e0ef556ebf190f04f1230b56f85895de4e249836"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1079bc2888950a7ccb25e291bb3120da6c8b445c1d98ebb9f71bd543777a502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ed3767d1118812a83bfd1d8189882eb7e0634c370e7456505a7bb4b07d819ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19dfec3d85b23cd17d16bffd1bc195e7f63e91090237726817292b6305fef6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b7807b8393d76b1e48525a5ef38835ad167f34c992aa0afd3a45719e868bb844"
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
