class Imsg < Formula
  desc "Send and read iMessage / SMS from the terminal"
  homepage "https://github.com/openclaw/imsg"
  url "https://github.com/openclaw/imsg/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "91cd6d59fc3b6fab6ac97165727446fd2cf542dac0be569aa6a13a5e1507893f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 arm64_golden_gate: "7780ba3355930fbe991203e284c96319737c623f46ac60810900f650da17957f"
    sha256 arm64_tahoe:       "54386a8f32c54881128c8ab556026c123fd8be6fc95ddba6a20fc2b1f84a12b1"
    sha256 arm64_sequoia:     "e2eaf29009e683a90ae3ef843a7464535b4a1cd38e489d4e307f8fd2c79ce37f"
  end

  # A version-specified macOS requirement is satisfied on Linux, so the bare one
  # is what actually keeps this off a platform it cannot support.
  depends_on :macos

  on_macos do
    # SQLite.swift needs swift-tools-version 6.1, first shipped in Xcode 16.3.
    depends_on macos: :sequoia
  end

  # Vendored because SwiftPM cannot fetch dependencies during a Homebrew build.
  # Versions match upstream's Package.resolved for this tag.
  resource "Commander" do
    url "https://github.com/steipete/Commander/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "5f584868a22b237f1c7106de04389c97c7825a1786431bf2b17f05f9df7bd40a"

    livecheck do
      url "https://raw.githubusercontent.com/openclaw/imsg/refs/tags/v#{LATEST_VERSION}/Package.resolved"
      strategy :json do |json|
        json["pins"]&.find { |pin| pin["identity"] == "commander" }&.dig("state", "version")
      end
    end
  end

  # Only linked on Linux, but SwiftPM still has to resolve it on macOS.
  resource "CSQLite" do
    url "https://github.com/stephencelis/CSQLite/archive/refs/tags/3.53.4.tar.gz"
    sha256 "099669b10a2ddab6889768f8c7836ee93fc2fc57c84c6c40d8e56eb125360738"

    livecheck do
      url "https://raw.githubusercontent.com/openclaw/imsg/refs/tags/v#{LATEST_VERSION}/Package.resolved"
      strategy :json do |json|
        json["pins"]&.find { |pin| pin["identity"] == "csqlite" }&.dig("state", "version")
      end
    end
  end

  resource "PhoneNumberKit" do
    url "https://github.com/PhoneNumberKit/PhoneNumberKit/archive/refs/tags/5.0.12.tar.gz"
    sha256 "8f3856e604a81d701e083bd740c48f1e941b9ea84078eb3453c56ae587dbdaec"

    livecheck do
      url "https://raw.githubusercontent.com/openclaw/imsg/refs/tags/v#{LATEST_VERSION}/Package.resolved"
      strategy :json do |json|
        json["pins"]&.find { |pin| pin["identity"] == "phonenumberkit" }&.dig("state", "version")
      end
    end
  end

  resource "SQLite.swift" do
    url "https://github.com/stephencelis/SQLite.swift/archive/refs/tags/0.17.0.tar.gz"
    sha256 "721a620a764f1e06bb5aac174b852b58eb84b63bcc5dd6b1df3637293c80ba96"

    livecheck do
      url "https://raw.githubusercontent.com/openclaw/imsg/refs/tags/v#{LATEST_VERSION}/Package.resolved"
      strategy :json do |json|
        json["pins"]&.find { |pin| pin["identity"] == "sqlite.swift" }&.dig("state", "version")
      end
    end
  end

  def install
    # patch-deps.sh takes a SwiftPM scratch path and patches "checkouts" beneath
    # it, so stage the vendored dependencies where it expects to find them.
    resources.each { |r| r.stage(buildpath/"vendor/checkouts"/r.name) }
    inreplace "Package.swift" do |s|
      s.gsub!(%r{\.package\(url: "https://github\.com/steipete/Commander\.git", from: "[^"]+"\)},
              '.package(path: "vendor/checkouts/Commander")')
      s.gsub!(%r{\.package\(url: "https://github\.com/stephencelis/SQLite\.swift\.git", from: "[^"]+"\)},
              '.package(path: "vendor/checkouts/SQLite.swift")')
      s.gsub!(%r{\.package\(url: "https://github\.com/stephencelis/CSQLite", from: "[^"]+"\)},
              '.package(path: "vendor/checkouts/CSQLite")')
      s.gsub!(%r{\.package\(url: "https://github\.com/PhoneNumberKit/PhoneNumberKit\.git", from: "[^"]+"\)},
              '.package(path: "vendor/checkouts/PhoneNumberKit")')
    end

    # Upstream patches its own SwiftPM checkouts before building; the resource
    # bundle lookup fix in there is what lets imsg find its metadata at runtime.
    system "scripts/patch-deps.sh", "vendor"

    system "scripts/generate-version.sh"
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "imsg"

    # Helper for the optional IMCore bridge, injected into Messages.app via
    # DYLD_INSERT_LIBRARIES. Messages on Apple Silicon rejects arm64-only.
    helper = "imsg-bridge-helper.dylib"
    arch_args = (Hardware::CPU.arm? ? %w[arm64e arm64] : %w[x86_64]).flat_map { |arch| ["-arch", arch] }
    ENV.permit_arch_flags
    system ENV.cc, "-dynamiclib", *arch_args, "-fobjc-arc",
           "-Wno-arc-performSelector-leaks", "-install_name", "@rpath/#{helper}",
           "-framework", "Foundation", "-framework", "AppKit",
           "-framework", "ImageIO", "-framework", "LinkPresentation",
           "-o", helper, "Sources/IMsgHelper/IMsgInjected.m"

    # Match upstream's ad-hoc signing so Automation and Contacts grants land on
    # the same bundle identifier a release build would use. The helper is left
    # alone: Homebrew rewrites its install name and re-signs it either way.
    system "/usr/bin/codesign", "--force", "--sign", "-",
           "--entitlements", "Resources/imsg.entitlements",
           "--identifier", "com.steipete.imsg", ".build/release/imsg"

    # imsg resolves its resource bundles and the bridge helper relative to the
    # real executable, so they all have to live in the same directory.
    libexec.install ".build/release/imsg", helper
    libexec.install Dir[".build/release/*.bundle"]
    bin.write_exec_script libexec/"imsg"

    # bin/imsg is not executable until the install finishes, so shell out to the
    # real binary here instead.
    generate_completions_from_executable(libexec/"imsg", "completions")
  end

  def caveats
    <<~EOS
      imsg needs Full Disk Access to read the Messages database:
        System Settings > Privacy & Security > Full Disk Access

      Sending also needs permission to control Messages.app:
        System Settings > Privacy & Security > Automation

      Advanced IMCore features (typing indicators, read receipts, edit/unsend,
      group management) additionally require SIP to be disabled. Check what is
      available with:
        imsg status
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imsg --version")
    assert_path_exists libexec/"imsg-bridge-helper.dylib"

    # Exercises the PhoneNumberKit metadata bundle without needing Messages
    # access or Full Disk Access.
    touch testpath/"chat.db"
    output = shell_output("#{bin}/imsg whois --address +14155551212 --type phone --local " \
                          "--db #{testpath}/chat.db --json")
    assert_match '"service":"unknown"', output
  end
end
