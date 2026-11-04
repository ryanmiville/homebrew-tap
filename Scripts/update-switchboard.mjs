import { createHash } from "node:crypto";
import { execFileSync } from "node:child_process";
import { createReadStream } from "node:fs";
import { mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

// Points Casks/switchboard.rb at the newest Switchboard release, after checking that the release,
// its release.json and the zip all describe the same build. Run by the "Update Switchboard"
// workflow; Switchboard's own Release workflow can start it as soon as it publishes.

const repository = "ryanmiville/switchboard";
const headers = {
  Accept: "application/vnd.github+json",
  "User-Agent": "switchboard-tap"
};
if (process.env.GH_TOKEN) headers.Authorization = "Bearer " + process.env.GH_TOKEN;
const releaseResponse = await fetch("https://api.github.com/repos/" + repository + "/releases", { headers });
if (!releaseResponse.ok) throw new Error("Release API returned " + releaseResponse.status);
const releases = await releaseResponse.json();
const release = releases.find((entry) => !entry.draft && !entry.prerelease &&
  /^v[0-9]+[.][0-9]+[.][0-9]+-[0-9]+$/.test(entry.tag_name));
if (!release) {
  console.log("No Switchboard release yet");
  process.exit(0);
}
const baseURL = "https://github.com/" + repository + "/releases/download/" + release.tag_name + "/";
const manifestResponse = await fetch(baseURL + "release.json");
if (!manifestResponse.ok) throw new Error("Manifest download returned " + manifestResponse.status);
const metadata = await manifestResponse.json();
if (!/^[0-9]+[.][0-9]+[.][0-9]+,[0-9]+$/.test(metadata.version) ||
    !/^[a-f0-9]{64}$/.test(metadata.sha256) ||
    !/^[a-f0-9]{40}$/.test(metadata.source)) {
  throw new Error("Invalid release manifest");
}
const [version, build] = metadata.version.split(",");
if (metadata.tag !== release.tag_name || metadata.tag !== "v" + version + "-" + build ||
    metadata.source !== release.target_commitish) {
  throw new Error("Release and manifest do not identify the same build");
}
const destination = "Casks/switchboard.rb";
const cask = [
  'cask "switchboard" do',
  '  version ' + JSON.stringify(metadata.version),
  '  sha256 ' + JSON.stringify(metadata.sha256),
  "",
  '  url "https://github.com/ryanmiville/switchboard/releases/download/v#{version.csv.first}-#{version.csv.second}/Switchboard.zip"',
  '  name "Switchboard"',
  '  desc "Opens each link in the browser profile chosen by your rules"',
  '  homepage "https://github.com/ryanmiville/switchboard"',
  "",
  '  livecheck do',
  '    skip "Releases are picked up by the tap workflow"',
  '  end',
  "",
  '  depends_on arch: :arm64',
  '  depends_on macos: :ventura',
  "",
  '  app "Switchboard.app"',
  '  binary "#{appdir}/Switchboard.app/Contents/Helpers/switchboard"',
  "",
  '  postflight_steps do',
  '    run "/usr/bin/xattr",',
  '        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Switchboard.app"],',
  '        writable_paths: ["Switchboard.app"],',
  '        writable_base:  :appdir',
  '  end',
  "",
  '  uninstall quit: "com.switchboard.app"',
  "",
  '  zap trash: [',
  '    "~/.config/switchboard",',
  '    "~/.local/state/switchboard",',
  '  ]',
  "",
  '  caveats <<~EOS',
  '    To route links through Switchboard, choose Set Default... in its Settings > General.',
  '    Keep only this copy: a copy built with scripts/install has the same bundle identifier.',
  '  EOS',
  'end',
  ""
].join("\n");
let current;
try {
  current = await readFile(destination, "utf8");
} catch (error) {
  if (error.code !== "ENOENT") throw error;
}
if (current === cask) {
  console.log("Switchboard is already current");
  process.exit(0);
}
const scratch = await mkdtemp(join(tmpdir(), "switchboard-cask-"));
try {
  const archive = join(scratch, "Switchboard.zip");
  execFileSync("curl", ["--fail", "--location", "--retry", "3", "--output", archive, baseURL + "Switchboard.zip"], {
    stdio: "inherit"
  });
  const hash = createHash("sha256");
  for await (const chunk of createReadStream(archive)) hash.update(chunk);
  if (hash.digest("hex") !== metadata.sha256) throw new Error("Release archive checksum does not match manifest");
  await mkdir("Casks", { recursive: true });
  await writeFile(destination, cask);
  console.log("Updated Switchboard to " + metadata.version);
} finally {
  await rm(scratch, { recursive: true });
}
