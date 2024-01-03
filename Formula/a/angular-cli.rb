require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.9.tgz"
  sha256 "27d5f0649b1949f5175f5408de65fcc56f47895c6ae0e0d17b9f14257f10bc4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec237ec3bb594b9f06d19d80194861a5c0bf7a613fb2e953be24e3f59da05df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec237ec3bb594b9f06d19d80194861a5c0bf7a613fb2e953be24e3f59da05df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec237ec3bb594b9f06d19d80194861a5c0bf7a613fb2e953be24e3f59da05df8"
    sha256 cellar: :any_skip_relocation, sonoma:         "86d55e383f3421b10bc78506a0ae9825c96d8d840a73dee17ca9f6a275330086"
    sha256 cellar: :any_skip_relocation, ventura:        "86d55e383f3421b10bc78506a0ae9825c96d8d840a73dee17ca9f6a275330086"
    sha256 cellar: :any_skip_relocation, monterey:       "86d55e383f3421b10bc78506a0ae9825c96d8d840a73dee17ca9f6a275330086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec237ec3bb594b9f06d19d80194861a5c0bf7a613fb2e953be24e3f59da05df8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
