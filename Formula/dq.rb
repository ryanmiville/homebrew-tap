class Dq < Formula
  desc "a small CLI for data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "27c363d505aa77eef2d13308faadaea8a346010c069ea7b426d2201d36c3f6d2"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
