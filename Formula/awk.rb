class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/20180827.tar.gz"
  sha256 "c9232d23410c715234d0c26131a43ae6087462e999a61f038f1790598ce4807f"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09cf1fe371a924c163732e19310f635953ae3f4909a9c3baa9db4ea4d850d905"
    sha256 cellar: :any_skip_relocation, big_sur:       "a73059712fb0cc9a57389f72596ca5c52978ad54bf9dce04baedbf653b154022"
    sha256 cellar: :any_skip_relocation, catalina:      "681acac2c4bac4b8f275f640abf46e5391216d800ff34ad8c57c8d116674fae6"
    sha256 cellar: :any_skip_relocation, mojave:        "202e81f1562d8b46d4b932f91c64ab58fc6017f6cdd2cc3f2a636038abc76fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43145524bd133b1b4f87bce5c1ea7c9d56ff3d97b60fa256581264aec660421" # linuxbrew-core
  end

  uses_from_macos "bison"

  conflicts_with "gawk",
    because: "both install an `awk` executable"

  def install
    ENV.deparallelize
    # the yacc command the makefile uses results in build failures:
    # /usr/bin/bison: missing operand after `awkgram.y'
    # makefile believes -S to use sprintf instead of sprint, but the
    # -S flag is not supported by `bison -y`
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "YACC=yacc -d"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
