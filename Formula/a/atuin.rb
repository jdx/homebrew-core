class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v17.2.0.tar.gz"
  sha256 "d82c7f4b0b3c04eb6ff1b26b1c4d5219622e1266ced9b48addf7976d2d90bd9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13c7a4f5ca50dbbdbb0b79bc642fa6564c454da2ee6d6b329cdd54672115dbb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "782ffdcd5f2c855ca9bbd8e3736686b3ce14945e13f7216ca87581befeb0f5b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941676190e8782c45a91da33fe8438d34b9fd4a04b8e66a3832c67ec8344b940"
    sha256 cellar: :any_skip_relocation, sonoma:         "9985e5774685df95d98a0a0eb65f3108e84d098d58a4fe80e378281c819a814d"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1cda6b970e2d9b950a7289d4172f32f0775a086adcca3410b486110b442ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "3c6ad816612d0a351daab5ed08bedd191b00d095d744b20b88d37412e922850e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f451633460c3bde9f6d93b86840a15dde73878e382d27ee70130b1f7abd718d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
