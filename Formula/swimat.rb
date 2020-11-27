class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/1.7.0.tar.gz"
  sha256 "ba18b628de8b0a679b9215fb77e313155430fbecd21b15ed5963434223b10046"
  license "MIT"
  head "https://github.com/Jintin/Swimat.git"

  livecheck do
    url "https://github.com/Jintin/Swimat/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f03f021887a387010e733167f87b37afb05a909b8bfa94d69793b43ea0e637c1" => :big_sur
    sha256 "a94df9efa0aef16df8e593696a3dc3dd1fbe4f8fa59512af713d4915a103843c" => :catalina
    sha256 "197ba3d1db2bfbee29a10e4735925b4fdac3035c486b7899bc564cea5f019839" => :mojave
  end

  depends_on xcode: ["10.2", :build]

  def install
    xcodebuild "-target", "CLI",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=",
               "SYMROOT=build"
    bin.install "build/Release/swimat"
  end

  test do
    system "#{bin}/swimat", "-h"
    (testpath/"SwimatTest.swift").write("struct SwimatTest {}")
    system "#{bin}/swimat", "#{testpath}/SwimatTest.swift"
  end
end
