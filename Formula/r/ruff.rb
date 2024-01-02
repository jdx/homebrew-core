class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "47cf8357c7036829ea859184cce125cd256b9f74afc2f5288c697facbb6f6677"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e76136fc9cc63869ea5ede245def823bc3554891cc78ed08319ee1bd6fe99591"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b34312b305a3e4dae1bee42fb2217e7a80012e17f5c89de21344d270f2e7b363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941b4af11b533ac74fbbdc62c7ae1432aa863feb9599735608714b036bdbf460"
    sha256 cellar: :any_skip_relocation, sonoma:         "72d6e58b9451e15371176f84580a085f10d6287cccfbbbf4915d41bc9e9590aa"
    sha256 cellar: :any_skip_relocation, ventura:        "aa96322d033efafbe9f6b8730d0748aea819858b21f02fca86a92c4728291d42"
    sha256 cellar: :any_skip_relocation, monterey:       "320025e4d29c9cacd65c04e8dc6302fe8a995c889e0be44e5a66360678c6eb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e7c811a01f3fb6bfdb5fa6e6994e9cdfef904f1887ceaff55016d2b52d8a32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
