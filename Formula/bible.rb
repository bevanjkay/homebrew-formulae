class Bible < Formula
  desc "CLI for YouVersion Suggest API"
  homepage "https://github.com/bevanjkay/custom-scripts"
  url "https://github.com/bevanjkay/custom-scripts/archive/refs/tags/bible-1.0.6.tar.gz"
  sha256 "2fd8363793ad9896d2a9f1f489e11a1ae3d1e27c98c7c0ed3cd015cf668752d9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^bible-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d960582d387de50ca1f857f4a0afe134950692fa06c9eb3e93f7d2561761ceb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6cb18f360d908d06b80cd33fb334d44ea76935483e5169183e95acc17198fa"
    sha256 cellar: :any_skip_relocation, ventura:       "8dc2bd717c40de93ace91aff09cf817a2a677b0275254205b2bc71ae9f823f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5fcf820eaf900394e796d480643f07ed7f509094d387b8bce09be253a7360c4"
  end

  depends_on "deno" => :build

  def install
    cd("bible") do
      system "deno", "install"
      system "deno", "run", "build"
      bin.install "bible"
    end
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output(bin/"bible john 3:16")
    assert_match("For this is how God loved the world", output)
  end
end
