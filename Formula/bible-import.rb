class BibleImport < Formula
  include Language::Python::Virtualenv

  desc "Import custom Bibles into ProPresenter"
  homepage "https://github.com/martijnlentink/propresenter-custom-bibles"
  url "https://github.com/martijnlentink/propresenter-custom-bibles/archive/refs/tags/2025-09-14.tar.gz"
  sha256 "78f0a065edc287d754fb6b11c5118c21d2ff7406cdc06f8cbb17eeb1471b2857"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d056246bfb056b21609e6eca69ac015557f7962c3595a8649dd75d27170250b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4885d56ac27165556894cec08a00c6d137db588ce5f0abaa6ad3820303133f58"
    sha256 cellar: :any_skip_relocation, ventura:       "41dc3c23a99cf82b3a434050a7b94b5dd08254cba76929011bf0f8447cb41137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2946de3193431f75061552f23f22d79499c26aec67f680e27105ea37f1b234a9"
  end

  depends_on "certifi"
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "python-packaging"
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pyinstaller" do
    url "https://files.pythonhosted.org/packages/94/94/1f62e95e4a28b64cfbb5b922ef3046f968b47170d37a1e1a029f56ac9cb4/pyinstaller-6.16.0.tar.gz"
    sha256 "53559fe1e041a234f2b4dcc3288ea8bdd57f7cad8a6644e422c27bb407f3edef"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/20/17/58309bc981794907429f352ed628008db5ead987dafc5b2bfb318804a949/pyinstaller_hooks_contrib-2024.8.tar.gz"
    sha256 "29b68d878ab739e967055b56a93eb9b58e529d5b054fbab7a2f2bacf80cef3e2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b2/5a/4c63457fbcaf19d138d72b2e9b39405954f98c0349b31c601bfcb151582c/regex-2025.9.1.tar.gz"
    sha256 "88ac07b38d20b54d79e704e38aa3bd2c0f8027432164226bdee201a1c0c9c9ff"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    inreplace "bible_import.spec",
              "target_arch='universal2' if sys.platform == 'darwin' else None,",
              "target_arch=None,"

    python3 = "python3.13"
    venv = virtualenv_create(buildpath, python3)
    venv.pip_install resources

    system "bin/pyinstaller", "bible_import.spec"
    bin.install "dist/bible_import" => "bible-import"
  end

  test do
    # The application creates a download folder in the current working directory
    # after initialisation. This test checks if the folder is created.
    fork do
      system bin/"bible-import"
    end
    sleep 20
    assert_path_exists testpath/"download"
  end
end
