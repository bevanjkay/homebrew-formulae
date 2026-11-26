class Memo < Formula
  include Language::Python::Virtualenv

  desc "Manage Apple Notes and Reminders from the command-line"
  homepage "https://github.com/antoniorodr/memo"
  url "https://github.com/antoniorodr/memo/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "42e277fae84aad702cb2adae26b148b7ad0063a6d0ca7aa9170e87b56eb43f7c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    manifest_sha256 "1922dabd38d403edfdca340866f70e4e797a0f0f9cbfc678da6a16a37825b900"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb1ad1ebadf4527cb6d58daddb0e8dc1996da8768b19ccb2934582d305e4adc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b11819a088f9afeca2abd8042d0e1c5f4b4e12e7cd3ee04e9df5e342fba3664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79f43462cf6b75b454de8f990a0234849762cade9eb93d92a4318d4e24952c55"
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
