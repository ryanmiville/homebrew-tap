import { createHash } from "node:crypto";
import { execFileSync } from "node:child_process";
import { createReadStream } from "node:fs";
import { mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

const repository = "ryanmiville/tinycast";
const headers = {
  Accept: "application/vnd.github+json",
  "User-Agent": "tinycast-personal-tap"
};
if (process.env.GH_TOKEN) headers.Authorization = "Bearer " + process.env.GH_TOKEN;
const releaseResponse = await fetch("https://api.github.com/repos/" + repository + "/releases", { headers });
if (!releaseResponse.ok) throw new Error("Release API returned " + releaseResponse.status);
const releases = await releaseResponse.json();
const release = releases.find((entry) => !entry.draft && entry.prerelease &&
  /^personal-v[0-9]+[.][0-9]+[.][0-9]+-beta[.][0-9]+-[0-9]+$/.test(entry.tag_name));
if (!release) throw new Error("No published personal beta build found");
const baseURL = "https://github.com/" + repository + "/releases/download/" + release.tag_name + "/";
const manifestResponse = await fetch(baseURL + "fork-release.json");
if (!manifestResponse.ok) throw new Error("Manifest download returned " + manifestResponse.status);
const metadata = await manifestResponse.json();
if (!/^[0-9]+[.][0-9]+[.][0-9]+-beta[.][0-9]+,[0-9]+$/.test(metadata.version) ||
    !/^[a-f0-9]{64}$/.test(metadata.sha256) ||
    !/^[a-f0-9]{40}$/.test(metadata.source) ||
    !/^[a-f0-9]{40}$/.test(metadata.upstream)) {
  throw new Error("Invalid release manifest");
}
const [version, build] = metadata.version.split(",");
if (metadata.channel !== "beta" || metadata.upstreamTag !== "v" + version ||
    metadata.tag !== release.tag_name || metadata.tag !== "personal-v" + version + "-" + build ||
    metadata.source !== release.target_commitish) {
  throw new Error("Release and manifest do not identify the same build");
}
const destination = "Casks/tinycast-personal.rb";
const cask = [
  'cask "tinycast-personal" do',
  '  version ' + JSON.stringify(metadata.version),
  '  sha256 ' + JSON.stringify(metadata.sha256),
  "",
  '  url "https://github.com/ryanmiville/tinycast/releases/download/personal-v#{version.csv.first}-#{version.csv.second}/Tinycast-Personal.zip"',
  '  name "Tinycast Personal"',
  '  desc "Personal beta builds of the Tinycast launcher"',
  '  homepage "https://github.com/ryanmiville/tinycast"',
  "",
  '  livecheck do',
  '    skip "Personal builds are updated by the tap workflow"',
  '  end',
  "",
  '  conflicts_with cask: ["tinycast", "tinycast-universal"]',
  '  depends_on arch: :arm64',
  '  depends_on macos: :tahoe',
  "",
  '  app "Tinycast.app"',
  "",
  '  postflight_steps do',
  '    run "/usr/bin/xattr",',
  '        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast.app"],',
  '        writable_paths: ["Tinycast.app"],',
  '        writable_base:  :appdir',
  '  end',
  "",
  '  uninstall quit: "com.tinycast.app"',
  "",
  '  caveats <<~EOS',
  '    Tracks upstream beta releases; updates are managed by Homebrew.',
  '    Choose Left Control under Tinycast Settings > General > Hyper Key.',
  '    Keep Caps Lock set to Control in macOS Keyboard > Modifier Keys.',
  '    On first switching from upstream, grant Accessibility to this fork.',
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
  console.log("Tinycast Personal is already current");
  process.exit(0);
}
const scratch = await mkdtemp(join(tmpdir(), "tinycast-personal-cask-"));
try {
  const archive = join(scratch, "Tinycast-Personal.zip");
  execFileSync("curl", ["--fail", "--location", "--retry", "3", "--output", archive, baseURL + "Tinycast-Personal.zip"], {
    stdio: "inherit"
  });
  const hash = createHash("sha256");
  for await (const chunk of createReadStream(archive)) hash.update(chunk);
  if (hash.digest("hex") !== metadata.sha256) throw new Error("Release archive checksum does not match manifest");
  await mkdir("Casks", { recursive: true });
  await writeFile(destination, cask);
  console.log("Updated Tinycast Personal to " + metadata.version);
} finally {
  await rm(scratch, { recursive: true });
}
