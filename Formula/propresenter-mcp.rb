class PropresenterMcp < Formula
  desc "ProPresenter 7 MCP Server"
  homepage "https://github.com/alxpark/propresenter-mcp"
  url "https://github.com/alxpark/propresenter-mcp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ea5345688f12777ceba61c81bfc72e5a4c3ef67940f353189a0abf39fbdb94e8"
  license "MIT"

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
    output = IO.popen("#{bin}/propresenter-mcp 2>&1") do |io|
      sleep 1
      Process.kill("TERM", io.pid)
      io.read
    end
    assert_match "ProPresenter MCP Server running on stdio", output
  end
end
