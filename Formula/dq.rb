class Dq < Formula
  desc "a small CLI for data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9ba30d3fd1f3b8f16e45ddd27cc32e51e3c72228478c143fd6fb32f2fe677569"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
