class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "a71ace05facbea5238ac6dbeb457dcbda179d9db4d4904f5e7ea59d3a23599d3"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library on Linux
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix.to_s if OS.linux?
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match "fnox #{version}", shell_output("#{bin}/fnox --version")

    # Generate test age key using system age-keygen
    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    # Test with age encryption
    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }

      [secrets]
      TEST_SECRET = { provider = "age", value = "test-value" }
    TOML

    # Set the secret properly so it gets encrypted
    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-value", "--provider", "age"

    # Test list shows the secret
    output = shell_output("#{bin}/fnox list")
    assert_match "TEST_SECRET", output

    # Test list --values shows decrypted value
    output = shell_output("FNOX_AGE_KEY='#{secret_key_line}' #{bin}/fnox list --values")
    assert_match "TEST_SECRET.*test-value", output
  end
end
