class Dq < Formula
  desc "a small CLI for data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b773f5328515fc34ce643630d4e6177003b4e2515c168da204cf0d20d4e619e6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
