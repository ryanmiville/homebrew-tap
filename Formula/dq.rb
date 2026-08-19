class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "42ce3018aa8993df3713ddf412a7972f3f0d20f24cf8fa57e384e1941c9a41ad"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.7.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4382ca9b5bf09435adcdb4d105aa8d96425bb7b26332cad8bcfbac0fd0a218d1"
    sha256 cellar: :any_skip_relocation, sequoia:       "3c973e89a4b056ab65f41ebd3a9c19c97b2f8f1e08ad6c6e990cf95e64e4c99a"
    sha256 cellar: :any,                 x86_64_linux:  "f73ed4767187ed1d56a71e014a6fefed1d79420223b486579d056d42d386f126"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
