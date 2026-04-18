class PropresenterPresentationBuilder < Formula
  desc "Generate ProPresenter presentation files from JSON input"
  homepage "https://github.com/bevanjkay/propresenter-presentation-builder"
  url "https://github.com/bevanjkay/propresenter-presentation-builder/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e75bf83c4d8417dfc60cba0c5fcf27e1a9ae44ad97311b5734dde25b41a4913c"
  head "https://github.com/bevanjkay/propresenter-presentation-builder.git", branch: "main"

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
