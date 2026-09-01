class Remindctl < Formula
  desc "Command-line access to Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1d525139879d8e1ad3a6cbb508106d129fca3c154c152cc1343bdd0f13abc92b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3811b61c53a43e692f4887b65f824909a285fe2bb2f4451e541c0e3e8a6ba73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "441b1a179b34543f03922dbc4770c412b49faae7e2814873416a67da91b16dba"
  end

  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  resource "Commander" do
    url "https://github.com/steipete/Commander/archive/refs/tags/v0.2.4.tar.gz"
    sha256 "33adc1d87615be729dceea38ee0358dec8484f35f7070caac29fe5e1902fcbd3"
  end

  def install
    resource("Commander").stage(buildpath/"vendor/Commander")
    inreplace "Package.swift",
              '.package(url: "https://github.com/steipete/Commander.git", from: "0.2.0")',
              '.package(path: "vendor/Commander")'

    system "scripts/generate-version.sh"
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "remindctl"

    system "/usr/bin/codesign", "--force", "--sign", "-",
           "--identifier", "com.steipete.remindctl", ".build/release/remindctl"

    bin.install ".build/release/remindctl"
    generate_completions_from_executable(bin/"remindctl", shell_parameter_format: :cobra,
                                                          shells:                 [:bash, :zsh])
  end

  def caveats
    <<~EOS
      remindctl needs Reminders access for the terminal app that runs it:
        System Settings > Privacy & Security > Reminders

      Trigger the prompt and check the current state with:
        remindctl authorize
        remindctl status
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remindctl --version")
    assert_match "complete -F _remindctl_completion remindctl",
                 shell_output("#{bin}/remindctl completion bash")
  end
end
