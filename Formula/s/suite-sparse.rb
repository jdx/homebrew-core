class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "f9a5cc2316a967198463198f7bf10fb8c4332de6189b0e405419a7092bc921b7"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99a35a720fad6c15d7b8a705efe6f6b5d274ad181e9293dc33b7e6b52ea7c7e2"
    sha256 cellar: :any,                 arm64_ventura:  "1457c274b7bb1f63cd835204bf0d5d2f110b9de3d5ff101d0d690805b8517393"
    sha256 cellar: :any,                 arm64_monterey: "bd069f2d216187ad52eb3d449feeada150dfc8966d761bc7049286b54bdc499e"
    sha256 cellar: :any,                 sonoma:         "d2061d7168a7cfa33e0d931fd73b1f04d7e888c0b0cd8a049ac64257f3ddca97"
    sha256 cellar: :any,                 ventura:        "5189b27530c37b7a20b3e7446b3436a7140968b9f1520fc6fef6801b4d12c5d6"
    sha256 cellar: :any,                 monterey:       "ec3ae42fc3fcb42fbe42f2ad2bae039316b5f43b770542c91b2e81475990900f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9740d4012be76d0d736ffec0baf0ccc479990ed0665822411f0d1289b70eae9f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # Avoid references to Homebrew shims
    if OS.mac?
      inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-I#{include}/suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
