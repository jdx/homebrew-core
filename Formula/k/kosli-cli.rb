class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "28afdb8c57fb652be6a16459e073c1c51b0800632c1676d16044d9005a61a02e"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ab3ddc2e743f30721149f2bba9cc02b636e3a5c6860f99755b6cb6780268929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8c123b3767020057bcb19966b8dd821ff9d08e8d4370079f96c47cf16d0a92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc4188bbe08342d72f2682c597948059e8081e92c03616d8b361d42604a293c"
    sha256 cellar: :any_skip_relocation, sonoma:         "88f8a925683738b1e321aa13d656081e672684ebd705cd31b41aead7632b2994"
    sha256 cellar: :any_skip_relocation, ventura:        "45060296f7b2fbd0a30c58818421914df5170ab22c2ea06538eba226f802ebe0"
    sha256 cellar: :any_skip_relocation, monterey:       "a13269ba6abdb04eaadd08dbc31fd58ad1be9d4ed72ccff3c7ced9bd02a15b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e274f796b0d653019b43ba7d97ec811ef396493f96cba083a5515484864a90c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
