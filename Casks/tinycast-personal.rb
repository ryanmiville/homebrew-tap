cask "tinycast-personal" do
  version "0.12.0-beta.122,30"
  sha256 "3b0eeba4b24ca2a52f12bf520ae17057c60694939032b8142e1a2827978bebb6"

  url "https://github.com/ryanmiville/tinycast/releases/download/personal-v#{version.csv.first}-#{version.csv.second}/Tinycast-Personal.zip"
  name "Tinycast Personal"
  desc "Personal beta builds of the Tinycast launcher"
  homepage "https://github.com/ryanmiville/tinycast"

  livecheck do
    skip "Personal builds are updated by the tap workflow"
  end

  conflicts_with cask: ["tinycast", "tinycast-universal"]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Tinycast.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast.app"],
        writable_paths: ["Tinycast.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.tinycast.app"

  caveats <<~EOS
    Tracks upstream beta releases; updates are managed by Homebrew.
    Choose Left Control under Tinycast Settings > General > Hyper Key.
    Keep Caps Lock set to Control in macOS Keyboard > Modifier Keys.
    On first switching from upstream, grant Accessibility to this fork.
  EOS
end
