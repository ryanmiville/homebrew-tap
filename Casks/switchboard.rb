cask "switchboard" do
  version "0.2.0,9"
  sha256 "4eeb766d7f236fa5a4b71ab2a429cae71534744ea126edd5fe4958651ed9633e"

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
