class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "42ce3018aa8993df3713ddf412a7972f3f0d20f24cf8fa57e384e1941c9a41ad"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
