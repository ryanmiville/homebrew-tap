class Dq < Formula
  desc "a small CLI for data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.0.1-alpha.11.tar.gz"
  sha256 "a7522e73b4313928ef7fbcae660e702875ac79769d3abbf63c711f6b64e091e0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
