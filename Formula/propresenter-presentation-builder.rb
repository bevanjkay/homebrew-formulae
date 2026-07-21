class PropresenterPresentationBuilder < Formula
  desc "Generate ProPresenter presentation files from JSON input"
  homepage "https://github.com/bevanjkay/propresenter-presentation-builder"
  url "https://github.com/bevanjkay/propresenter-presentation-builder/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "99c096ae37531265718490a202ac3c54d613509ca890b9b1392243d6f3e261c0"
  head "https://github.com/bevanjkay/propresenter-presentation-builder.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce08050d9647bc69d8f5a54d1f0a90dfc2d594488257bb63f189ab4fc1960f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008e424f9a21ca783f7d5edcb74d0930c770b2dab986229036d170501880f504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1921a641f0e2db5eecd947f970d32ee63d4d5ebd32dbea3b948a7dd7a10a5945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802598d4777b68af42a9d6284af90eed2e939c41ab5a6bb403c19bb0d2e48301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b786414f0bdcb9d14281241e6ebf04a458bd9486ca9f7ac349cf2aeaff1859c"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  def install
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "build"
    system "pnpm", "prune", "--prod"

    (bin/"propresenter-presentation-builder").write <<~EOS
      #!/bin/bash
      exec node #{libexec}/dist/cli.js "$@"
    EOS
    (bin/"propresenter-presentation-builder").chmod 0755
    libexec.install "dist", "node_modules", "package.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/propresenter-presentation-builder --version")
    (testpath/"input.json").write <<~JSON
       [
        {
          "type": "title",
          "text": [
            {
              "label": "Title",
              "text": "Title"
            }
          ]
        }
      ]
    JSON
    system bin/"propresenter-presentation-builder", "generate", "--input", testpath/"input.json", "--output",
testpath/"output.pro"
    assert_path_exists testpath/"output.pro"
  end
end
