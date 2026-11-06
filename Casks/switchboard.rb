cask "switchboard" do
  version "0.3.0,10"
  sha256 "6b0e14650956a48a7f9831343cc8ef0e838aef9cf37e3030659c1c07bf0a5d48"

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
