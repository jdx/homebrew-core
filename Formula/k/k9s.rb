class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.30.8",
      revision: "d0f874e01a747d8851f0751e2fd7677266733f7f"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec25e850ebbfcb836d4bb0be2603aac79c2084d305d2281c49ca42a9beafd81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a425470b8991d478b3046e34e1e06d5f919db6d02051fdbbc489ff856a48a402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28e038b9e7dffb5e46f4626121e8c1c69826f371a40f940e9f24d90fd2794037"
    sha256 cellar: :any_skip_relocation, sonoma:         "9be86a8d00a7eefacd4cef8f48efd092d83c3840a26a1eae5c397a1d79316713"
    sha256 cellar: :any_skip_relocation, ventura:        "cd303aaad79ccb98efec745478168c29817f5564236445f304b79837f3df8cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "295a131062e1d154dd53a4f6b5e4ef698b41d37401acf0263852f45731e0af9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7127a90987486640545322f8f40fd14af7fb2a37066afb4c1969cd9c888651d4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
