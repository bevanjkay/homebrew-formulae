class PropresenterPresentationBuilder < Formula
  desc "Generate ProPresenter presentation files from JSON input"
  homepage "https://github.com/bevanjkay/propresenter-presentation-builder"
  url "https://github.com/bevanjkay/propresenter-presentation-builder/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e75bf83c4d8417dfc60cba0c5fcf27e1a9ae44ad97311b5734dde25b41a4913c"
  head "https://github.com/bevanjkay/propresenter-presentation-builder.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8a072f777bd30c3999940d7dda230ecb434a08c437de3df751cadf434416f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8065582623a4e47cb27237ca5647868c7f2ee7406348a93aeb85572909c8933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa18fa7858426e8bedee01bcce5fb5382eeb48c63f25ae4eea024a4bc0baf1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f60afb5af7877e1c8560fb3471ec636d3b5c338dc3f56274e47d75487b7fbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d62d8e687371aa6b56d9b15506d56cfc0e5dfd5dc74e2f7d8c6a3e27816c0ff"
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
