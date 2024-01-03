require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "826bbd4bfa492b06568465c157b135df01c2b634fd7ed16bca8958c569aff153"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "742e3c5ec4e28acccda8fc1a95a37caf494dc3d274f9410e600c3ef15c0d56c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1113284be0571c1acf6f9f65f3289c50a2ebf110c0f687b2f80d9d79fa5fbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8551a4589f03806a1ea885b741cf96497e712699cbe7fc856a8a5a3e7ed6b8ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3b8e510fb113080d3ad75f811d2854c82ed3b76548cd8fbd10c5353716f5679"
    sha256 cellar: :any_skip_relocation, ventura:        "4d81b738ee9b1b1b1877878e64ae5967186317a293798b1583a74818fc87cef2"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e61618ed593158956f3f58feaca91a662570dcd3d4b785d26ddddd470d0df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "952ad2a259712352965566b1493f98030d7bf116fd6f0b1796bdc6d14f6d9aae"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
