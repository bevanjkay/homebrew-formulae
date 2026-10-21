class Memo < Formula
  include Language::Python::Virtualenv

  desc "Manage Apple Notes and Reminders from the command-line"
  homepage "https://github.com/antoniorodr/memo"
  url "https://github.com/antoniorodr/memo/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "17015996aac2c76ccd721ad9709816d186216474ff90e553e53c488c681cdb34"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af564b061df15f3b761304ee97ff7d9d52d67a5ba3a8bd81396a971661de0767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ddda3406217e61292fc0b21e0d121312433e4db96d08ac8681787df97484abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6787f2422ffe17858531dda50d43a1b6938e3d8b946095a91ba47364cf21820b"
  end

  depends_on :macos
  depends_on "python@3.14"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/47/92/3d893ac5d338b9a9af34c5b517d77492dcea8a10254254eead4215a96f3f/chardet-7.7.0.tar.gz"
    sha256 "0ba38a05201b0abf7570c12d8af45c30b2af835bd5cc52bfc7105082eda82c1e"

    livecheck do
      url :url
    end
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"

    livecheck do
      url :url
    end
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"

    livecheck do
      url :url
    end
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/96/eb/749a4e69bf7396e751ae37444abe997eff2254e695a8095b84d1c89c1181/mistune-3.4.0.tar.gz"
    sha256 "2eaf7952af928ca8d33b779762effc1da517b62c6ad85ec8ca957e3b07b9782a"

    livecheck do
      url :url
    end
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"

    livecheck do
      url :url
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memo --version")
  end
end
