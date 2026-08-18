class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9ba30d3fd1f3b8f16e45ddd27cc32e51e3c72228478c143fd6fb32f2fe677569"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.6.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a36f76622075a9eb4ce8060058c57cd95e8ee0c55dbcad6213db844f8b22b88"
    sha256 cellar: :any,                 x86_64_linux:  "533a45e26682727b2fb0d1a2edf2d73e77a452bd1148560f693e63b46bd960c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
