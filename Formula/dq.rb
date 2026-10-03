class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4e9218154a6cc6c187fff94566eb6b02a3a3eb294b650179b31019932d59c39d"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.8.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0468891c9f84993c6d92e103ad2a3a78e8af7c9efbc4db1551c15646f2b40be1"
    sha256 cellar: :any_skip_relocation, sequoia:       "2b15ce5368342d6ea36aedc30b12d65c8d0cc8b37205a107de456e22cb4e6dcb"
    sha256 cellar: :any,                 x86_64_linux:  "8f294f63475e401a6bf7afc2ba3d69833abca22d15a50ac587778f7e00b882a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
