class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "d7d973c960520289f10142edf6d64dc1bbb1fc207723129f31bfb949ba20f4d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8c4e4a6641a6acdc85b3ecac8bad40246f21385967e894c2cfb4ad09863b621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c4e4a6641a6acdc85b3ecac8bad40246f21385967e894c2cfb4ad09863b621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c4e4a6641a6acdc85b3ecac8bad40246f21385967e894c2cfb4ad09863b621"
    sha256 cellar: :any_skip_relocation, sonoma:         "7aefb4c536c6ae1e1dfb5a85b38e25f21880fb308033d185dfeb40566e113924"
    sha256 cellar: :any_skip_relocation, ventura:        "7aefb4c536c6ae1e1dfb5a85b38e25f21880fb308033d185dfeb40566e113924"
    sha256 cellar: :any_skip_relocation, monterey:       "7aefb4c536c6ae1e1dfb5a85b38e25f21880fb308033d185dfeb40566e113924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd91a862b84341bcf4bd2a7a1adfbaccf450f19ead949f4144b7865c07e90ca"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
