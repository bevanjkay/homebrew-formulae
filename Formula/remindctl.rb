class Remindctl < Formula
  desc "Command-line access to Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "25a18712ae80580e854afe4fc5b6deedea3346000edf837b65d41f1f5abc1dee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75dc17fc88fade782f03a57e74621df1ca5eb0291e342c6a2670b3892d7763ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "427a1470720d2adad0ff73647f8ea7d886a499ffdc9e1a6779d6e1efee8fdb95"
  end

  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  resource "Commander" do
    url "https://github.com/steipete/Commander/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "5f584868a22b237f1c7106de04389c97c7825a1786431bf2b17f05f9df7bd40a"
  end

  def install
    resource("Commander").stage(buildpath/"vendor/Commander")
    inreplace "Package.swift",
              %r{\.package\(url: "https://github\.com/steipete/Commander\.git",(?:[^()]|\([^()]*\))*\)},
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
