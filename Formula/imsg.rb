class Imsg < Formula
  desc "Send and read iMessage / SMS from the terminal"
  homepage "https://github.com/openclaw/imsg"
  url "https://github.com/openclaw/imsg/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "05df5c4042eba490cdc33493e06e4eed1f691eafc2e76dde77f5eb1add1fb707"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/bevanjkay/formulae"
    sha256 arm64_tahoe:   "154610348a76757194d083bb1ec21763e41747562c2b40f28dfa56292f8be5c3"
    sha256 arm64_sequoia: "c52a27d7410f074fceb850e67ce507ec415ddeeff3840130483a2df8783da30b"
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
  end

  resource "PhoneNumberKit" do
    url "https://github.com/PhoneNumberKit/PhoneNumberKit/archive/refs/tags/5.0.10.tar.gz"
    sha256 "2a54311daabae5863e2f0d5255e61bf29ea0db9d24157eb2fe5e76a3783fbba9"
  end

  resource "SQLite.swift" do
    url "https://github.com/stephencelis/SQLite.swift/archive/refs/tags/0.16.0.tar.gz"
    sha256 "b5a495909a7d4e31d85edf12bfede358222d3fe837f181a0faa79e3563060844"
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
