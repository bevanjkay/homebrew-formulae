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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63ed8442f8af01a5588cd9e81af258eb2a3c30ff76e7ed842301d900d5159803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03c59cd6b0ade85c2ff91606237f87ab239efb3ed1dc43d8d6eca10b35c8b089"
    sha256 cellar: :any_skip_relocation, ventura:       "35541752c7c6740be90f4aa2ddb32dadf29002e5bd42e155c2892793f6c447c1"
    sha256 cellar: :any_skip_relocation, monterey:      "737c5e04c4b48615bcede664a007e2b804f82a813544cb19312619d7c3a9ef0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7296700d5bde372b2c9ed94020b96497043415ed8a669cb1a3c7a76f0676c524"
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
