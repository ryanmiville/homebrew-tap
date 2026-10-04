class Dq < Formula
  desc "Shell-first data pipelines powered by DuckDB"
  homepage "https://github.com/ryanmiville/dq"
  url "https://github.com/ryanmiville/dq/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "997ff2791d1a02c715c23f35560a9a36a14d0f87511f80106cb89ecda59bee00"
  license "MIT"

  bottle do
    root_url "https://github.com/ryanmiville/homebrew-tap/releases/download/dq-0.8.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c843e3fd14779cd3fc59da3374f74430f2bf353b2346c7238d6c4c21113a3e5"
    sha256 cellar: :any_skip_relocation, sequoia:       "0ea6ecdebbec7386b0b64db0fe80231c65c72cbf599bad9902a1959478f74a16"
    sha256 cellar: :any,                 x86_64_linux:  "4bc99a3f902a88f7adb507eac966347242ad72d2fdd7a6c22bb58d977b983d54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dq", shell_output("#{bin}/dq --help")
  end
end
