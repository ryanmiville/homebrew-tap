cask "tinycast-personal" do
  version "0.11.12,7"
  sha256 "fd6b0afc3f1aafb460a8ec75f4bef98234a7494f82bd71f402306127a57dfae0"

  url "https://github.com/ryanmiville/tinycast/releases/download/personal-v#{version.csv.first}-#{version.csv.second}/Tinycast-Personal.zip"
  name "Tinycast Personal"
  desc "Menu-bar launcher with Left Control as Hyper"
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
    Choose Left Control under Tinycast Settings > General > Hyper Key.
    Keep Caps Lock set to Control in macOS Keyboard > Modifier Keys.
    On first switching from upstream, grant Accessibility to this fork.
  EOS
end
