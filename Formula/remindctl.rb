class Remindctl < Formula
  desc "Command-line access to Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ad0cb1d57f5b112f351a9e16afcc8d1df2006bb728ea8675db4d7bab9f1cbf4a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a9bf4fcb9a039cf0f99de031fb62f86d973397b0ba8573f9831494308ff4d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ffed3b1321fd7f34f2d1118ddc40995dcbd93e7b54742905da67b080661d1b4"
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
