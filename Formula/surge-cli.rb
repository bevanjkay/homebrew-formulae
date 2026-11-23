class SurgeCli < Formula
  desc "CLI client for the surge.sh hosted service"
  homepage "https://surge.sh/"
  url "https://registry.npmjs.org/surge/-/surge-0.58.0.tgz"
  sha256 "822948e859a0cc36dc5592a717e2b0d782b72386695c3732a9fca238e91296ea"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73c1ac544e7174cc206c94a6a3695ac0293da746ed116ff7b876536b944cf581"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05a21ff2128e77ba3ad46b3cef6987b4c1f33aa3168eb05bc95625f87254d16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d00d56d3175c52a844facde664db217fc4180a6fe7b18e3197ae5f8e523d0877"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "342d57afcc60b490feeadf8292b73b5d001370ab1a6187f149fb8d004da85977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "23bc0c76220ffb3b13210165ad21ed194b599d749b58515575baac033853c8b4"
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
