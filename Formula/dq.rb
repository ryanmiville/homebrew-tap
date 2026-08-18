class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9ba30d3fd1f3b8f16e45ddd27cc32e51e3c72228478c143fd6fb32f2fe677569"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.6.0"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "322ce610e212f7e495d4319083534f94bfd44c0224fe30b3fe2ffecbe373884f"
    sha256 cellar: :any_skip_relocation, sequoia:       "ceff5c1d0026b2d9f481894f1aaf650388bb1c4ddf519227ec8a90d8ad4ef738"
    sha256 cellar: :any,                 x86_64_linux:  "558e36db0df6f44c36680239d0ce9ea4c183e46c40e27fc454afac3a9720193b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
