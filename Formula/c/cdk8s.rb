require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.25.tgz"
  sha256 "7b8bd7720166e9ef8d6aba1f28be3ab2ceac42b735d54170c07f3a4f14b4efdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fb5684d7a89d978a6eedafacb3ee9bb46879567036fab74e4f2ab901e31dfc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fb5684d7a89d978a6eedafacb3ee9bb46879567036fab74e4f2ab901e31dfc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb5684d7a89d978a6eedafacb3ee9bb46879567036fab74e4f2ab901e31dfc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a75a69f260d54f5aac17615fa5fc27d0ff9dd853c9e0af2895e936bcb3bd7244"
    sha256 cellar: :any_skip_relocation, ventura:        "a75a69f260d54f5aac17615fa5fc27d0ff9dd853c9e0af2895e936bcb3bd7244"
    sha256 cellar: :any_skip_relocation, monterey:       "a75a69f260d54f5aac17615fa5fc27d0ff9dd853c9e0af2895e936bcb3bd7244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb5684d7a89d978a6eedafacb3ee9bb46879567036fab74e4f2ab901e31dfc8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
