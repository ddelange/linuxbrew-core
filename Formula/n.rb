class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.10.tar.gz"
  sha256 "41321109f410fc9b9c182773cf68fc0dc525fa640ebf7f7ed855c3dfbe023fc6"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :high_sierra
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :sierra
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :el_capitan
    sha256 "e1990ec0d7e0483aa4e7d92ba9fae8ebf27c98af4e6f7bd2a3af753fd0a5e8c6" => :x86_64_linux
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
