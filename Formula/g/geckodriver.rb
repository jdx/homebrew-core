class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "bc25087baba17c78246db06bcab71c299fd8f46f"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.34.0"
    sha256 "2282fe6ab8cca3fadbf496b68bbc08632e3084469306ca45ddf757c60232822f"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "e18be4234433080dff4da5cd9ec5948a33fd38b14b069f4204bb1e4d6fdd0de7"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "441ef05f4f66d9362c3064dc65c305f56ef1e7be6bd3d648d0d5c1b0fa6a4940"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "19452b7f17cae89d6b7b8e4fad55ced0a95fa6cd850299733fcd237f598363d1"
    end
  end

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd78430189604f5c19a453a34ba41607c126d4de8c9973eafa16b2926c60e91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58e395855e57f06d764c3def6d6d097258e02635a71ab3966192738cc5eecffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf155d33ba2b30186ed870e1413e37b6074d28053439d9072170f109328fcb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f157c4a44d2015c691e83162c2f99616b806787059f89efa576b95cff83301"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc3ca9568521dca4942e298c3e6345a33be01c9fb01ade0b924c60d9db56e50"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8893249096660b0a31c030e402fd19971a41445e0a6b2435c27672c604d510"
    sha256 cellar: :any_skip_relocation, monterey:       "a38132365353a169d06c78d167aec5cd2d366e7300302f516aa3c1205eab1cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "520359529fe9f90c5fb182acf27421c39603bf7f43756ada27632e34c90538e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193f488a95a9ac7ec532f3284a619173208fc26da0fe2bd5140a5bdf418c6aff"
  end

  depends_on "rust" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "unzip"

  def install
    unless build.head?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging"/"testing"/r, buildpath/"testing"
        rm_rf buildpath/"staging"/"testing"
      end
      rm_rf buildpath/"staging"
      (buildpath/"testing"/"geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    fork do
      exec "#{bin}/geckodriver --port #{test_port}"
    end
    sleep 2

    system "nc", "-z", "localhost", test_port
  end
end
