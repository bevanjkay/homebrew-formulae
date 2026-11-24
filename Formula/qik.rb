class Qik < Formula
  desc "Command-line access to the qik platform for people, scripts and AI agents"
  homepage "https://qik.dev"
  url "https://registry.npmjs.org/@qikdev/cli/-/cli-2.0.0-alpha.3.tgz"
  sha256 "175eeae31437e7fbfa0fc1adedf45fc26408d2492d6df0f69e69ae5ba3ed8de9"
  license "ISC"

  # Without a livecheck block, versions containing "alpha", "beta" or "rc" are
  # rejected, and every 2.x release so far is a prerelease.
  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    rebuild 1
    manifest_sha256 "284b937b2313dedaf59bd4ccc52fb8c6e5d1c0698e0b1e4b97d20656c845531b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97d52573ffee9bad3cbfc0f436ffcade039053f4d116d26dce2f6f2226a5ae32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb97f6c29c75cafc16085a15d1c92a73500b46dcdf35c02e7b53e9966ed65d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f902aa5bf861aee2f55d59c61403f8bccdb66ab9d9f425bbf7f0370d8959703a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "280513fa129fcb75a818c7fefe39918124e95719535bd2a48903f9e87c0b8d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1a8687ba4d78ee96d90034aecd31377c39bc935331668cc0d23744735d63af74"
  end

  # The npm package is only a Node launcher for the self-contained binary in
  # these per-platform packages. It stays as the stable URL so `brew bump` can
  # update this formula: it cannot rewrite per-platform URLs in on_* blocks, but
  # it does update top-level resources that follow the parent's version.
  resource "darwin-arm64" do
    url "https://registry.npmjs.org/@qikdev/cli-darwin-arm64/-/cli-darwin-arm64-2.0.0-alpha.3.tgz"
    sha256 "99bb387d65ea36570656b231526e9f8b1920a1371c6f8873a4f3de8f3288b92e"

    livecheck do
      formula :parent
    end
  end

  resource "darwin-x64" do
    url "https://registry.npmjs.org/@qikdev/cli-darwin-x64/-/cli-darwin-x64-2.0.0-alpha.3.tgz"
    sha256 "43776300c4ae94edf49d00754ab9fd98e4dfb743e0544742a875e05ee222288e"

    livecheck do
      formula :parent
    end
  end

  resource "linux-arm64" do
    url "https://registry.npmjs.org/@qikdev/cli-linux-arm64/-/cli-linux-arm64-2.0.0-alpha.3.tgz"
    sha256 "6a307741f3c2f585dbe8ae41eb8b7b171bd999276d6135db688543059ec7b8c2"

    livecheck do
      formula :parent
    end
  end

  resource "linux-x64" do
    url "https://registry.npmjs.org/@qikdev/cli-linux-x64/-/cli-linux-x64-2.0.0-alpha.3.tgz"
    sha256 "ed2cf23173af264b4205c3823d51effd3f4e2826ef0bcaa4a485c8770a375833"

    livecheck do
      formula :parent
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform = "#{os}-#{arch}"
    resource(platform).stage { bin.install "bin/qik" }

    generate_completions_from_executable(bin/"qik", "completions")
  end

  test do
    ENV["QIK_CONFIG_DIR"] = testpath

    assert_match "qik #{version}", shell_output("#{bin}/qik --version")
    assert_match "Not logged in", shell_output("#{bin}/qik whoami 2>&1", 3)
  end
end
