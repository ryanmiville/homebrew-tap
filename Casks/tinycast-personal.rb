cask "tinycast-personal" do
  version "0.12.1-beta.123,33"
  sha256 "3329822de8be99ee9eafad5d89b1104c8fdf1025e1ae4ca4e2c2fc8e50006d17"

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
