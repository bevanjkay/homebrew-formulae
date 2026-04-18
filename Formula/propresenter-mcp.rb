class PropresenterMcp < Formula
  desc "ProPresenter 7 MCP Server"
  homepage "https://github.com/alxpark/propresenter-mcp"
  url "https://github.com/alxpark/propresenter-mcp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ea5345688f12777ceba61c81bfc72e5a4c3ef67940f353189a0abf39fbdb94e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "256cee079b3053fda7cb5ab6871a7831d4ceb2bf72d20ff4341b1c0669b10ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bd617d8a9e0a6d9425217b9e40da0af920d60b4149d369a871e4ab3ee09ae23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd7a59fa7cac87ec136b02a95b93c471e2f3e1e499b43826fbaebbd1a8e1138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2de36e2e7380880b490aa934fedb9892eebc13ed6385f230344a8b4126990e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec1bd9f3a1361d771d853dd618f89266de019b2a3382b7cdfac77baac6a8b30"
  end

  depends_on "typescript" => :build
  depends_on "node"

  def install
    system "npm", "install", "--include=dev", *std_npm_args(ignore_scripts: true)

    pkg_dir = libexec/"lib/node_modules/@alxpark/propresenter-mcp"
    system "npm", "--prefix", pkg_dir, "install", "--include=dev", "--ignore-scripts", "@types/node"
    system "npm", "--prefix", pkg_dir, "run", "build"
    system "npm", "--prefix", pkg_dir, "prune", "--omit=dev"

    (bin/"propresenter-mcp").write <<~EOS
      #!/bin/bash
      exec node #{pkg_dir}/build/index.js "$@"
    EOS
    (bin/"propresenter-mcp").chmod 0755
  end

  test do
    r, w = IO.pipe
    pid = spawn(bin/"propresenter-mcp", [:out, :err] => w)
    w.close
    sleep 1
    Process.kill("KILL", pid)
    Process.wait(pid)
    assert_match "ProPresenter MCP Server running on stdio", r.read
  end
end
