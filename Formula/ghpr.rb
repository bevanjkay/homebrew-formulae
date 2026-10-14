class Ghpr < Formula
  desc "Approve and automerge GitHub PRs"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/ghpr-1.4.0.tar.gz"
  sha256 "77e78d870663b2a00baa08f26421edcb8e1c1c833f9cfb00e0bc024ce37c486a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^ghpr-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "482cbb1dd3f0f7a21426039878a20ef6a08f989d5b36a76d2ad1fc783d586eff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73771d48253469c9d98f40c76bd4339735c6835768ed94b69694274b48a4183b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d72078fdb6bf1c016a626690b2619a89860de2ad2f0374fff2f16dafa564603"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "36b5da610c36b8e4581748368e7513ef1efe0f87f581b39d1f54d25f0a89488f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "060b3fda22414847733ae66c5c60c56cba28d56c11bff313c2403e24ccbb56a8"
  end

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build", "--workspace", "ghpr"
    cd("ghpr") { system "npm", "install", *std_npm_args }
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ghpr 2>&1", 1)
    assert_match "required option", output

    output = shell_output("#{bin}/ghpr --help")
    assert_match "Automate PR approvals and merges", output
  end
end
