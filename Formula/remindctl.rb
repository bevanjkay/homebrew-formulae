class Remindctl < Formula
  desc "Command-line access to Apple Reminders"
  homepage "https://github.com/openclaw/remindctl"
  url "https://github.com/openclaw/remindctl/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "f3968efce8c80bf2b4031a50ad3bfdbcc055ec49afe5f1c5fba581596f8b4569"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92446a58dfdcd54d383f18dcaf0f4a87feeaff21ff07a40c7d75e6921cc37cba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce3612714e16181549a9a798c944629eb3c638c1d079a92635a62ad1a18516a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db509d4e816072c7c4003e563224f59ab08ca28f662d25f5e446c3206916cef0"
  end

  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  resource "Commander" do
    url "https://github.com/steipete/Commander/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "5f584868a22b237f1c7106de04389c97c7825a1786431bf2b17f05f9df7bd40a"

    livecheck do
      url "https://raw.githubusercontent.com/openclaw/remindctl/refs/tags/v#{LATEST_VERSION}/Package.resolved"
      strategy :json do |json|
        json["pins"]&.find { |pin| pin["identity"] == "commander" }&.dig("state", "version")
      end
    end
  end

  def install
    resource("Commander").stage(buildpath/"vendor/Commander")
    inreplace "Package.swift",
              %r{\.package\(url: "https://github\.com/steipete/Commander\.git",(?:[^()]|\([^()]*\))*\)},
              '.package(path: "vendor/Commander")'

    # Swift 6.1 (Xcode 16) misreports a data race on the closure's implicit captures
    inreplace "Sources/RemindCore/EventKitStore.swift",
              "originalCalendarID) {\n",
              "originalCalendarID) { [eventStore, reminder] in\n"

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
