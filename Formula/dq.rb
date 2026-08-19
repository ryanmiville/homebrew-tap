class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "72de0fe2ed527bb106a1e929f9cb74380ac8035d9fe8ce808090f7b9abf13af2"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.7.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab23786292f9412409e7829edf0ba6e9f43253200cf9fceab4c0518950ba7c0"
    sha256 cellar: :any_skip_relocation, sequoia:       "c208b45e144ad75a2093196e40164c6b9765b5af710e880f18c7cf182530e1a4"
    sha256 cellar: :any,                 x86_64_linux:  "7335defba7311c75b58776eab35bc6bba1f482f1932aaade6c223f4fa01e4270"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
