cask "switchboard" do
  version "0.1.0,1"
  sha256 "6c76d25f01a37823fc5a3c18a18b168496f0f591f9e9239c2df70e1f91edaaaf"

  url "https://github.com/ryanmiville/switchboard/releases/download/v#{version.csv.first}-#{version.csv.second}/Switchboard.zip"
  name "Switchboard"
  desc "Opens each link in the browser profile chosen by your rules"
  homepage "https://github.com/ryanmiville/switchboard"

  livecheck do
    skip "Releases are picked up by the tap workflow"
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Switchboard.app"
  binary "#{appdir}/Switchboard.app/Contents/Helpers/switchboard"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Switchboard.app"],
        writable_paths: ["Switchboard.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.switchboard.app"

  zap trash: [
    "~/.config/switchboard",
    "~/.local/state/switchboard",
  ]

  caveats <<~EOS
    To route links through Switchboard, choose Set Default... in its Settings > General.
    Keep only this copy: a copy built with scripts/install has the same bundle identifier.
  EOS
end
