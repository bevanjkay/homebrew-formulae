class SevenzipLegacy < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2408-src.tar.xz"
  version "24.08"
  sha256 "aa04aac906a04df59e7301f4c69e9f48808e6c8ecae4eb697703a47bfb0ac042"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3844336c8a61bfdb95b1f4241d9a375c3d1ea145d71ad819c53e2cd16ca4a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c91f3b002f0cb493a5e1c9571784fc192ba553e8d924f4d2933a81b9b48e29"
    sha256 cellar: :any_skip_relocation, ventura:       "f178078be5e74daccbf7646d98831b18c94ba51175733fa465df13b43f0a7a44"
    sha256 cellar: :any_skip_relocation, monterey:      "6210894327071dc44a3f74a05e16e5a9b68897b5e5f5fb4076afd5187e3c40f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66bd97c93cacf6c8122b77a475a423c4ab078ad385c615eb0b2fa0da32efdd0"
  end

  depends_on macos: :monterey

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end
