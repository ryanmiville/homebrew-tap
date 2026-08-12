class Dq < Formula
  desc "a small CLI for data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cea66ddd32b6ab37b393448054e9eb8924eeccc5751e963a93402779aa269e4a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
