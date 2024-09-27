class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "14158168c99c5d694672861d127b541811d60f3e93b7ab4f3d85f22f1a9dd490"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b30006645dc5ada65b92067e5589e9cc8b2b3924e11d23a755c6a55d846dfb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30b5bab9eb390036309969611a5859145118fc111ecd5aa2704186b0244e23d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5a4d2051c92bead4049a3aab95b461091c86c6de007c6d98b10fc74fa639b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9228362ff637c416e8dd025ec5f735bfbcb08c9ec4d727f62980e9986cf2de36"
    sha256 cellar: :any_skip_relocation, ventura:       "8135c622a533f6db2ed8d1d8e67138e3b35f3205a669980e7a03ee3d723f72c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf835eafe5cb9afc141a92ed364d4c976ea8a37b0a070cfecb248ab569f52225"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
