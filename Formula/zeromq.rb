class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.4/zeromq-4.3.4.tar.gz"
  sha256 "c593001a89f5a85dd2ddf564805deb860e02471171b3f204944857336295c3e5"
  license "LGPL-3.0-or-later" => { with: "LGPL-3.0-linking-exception" }

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eb0ee61f9c1e894c9ad5e55a5a8bc0b3859d56fab57179f82e3e41df6ca4b9f5"
    sha256 cellar: :any, big_sur:       "579862174f4ce6883fe9871e52d0d4306c8daa67ecc7b5ab94c6174e29bb54bb"
    sha256 cellar: :any, catalina:      "64bdc5d8d6cc656f1a086157bdbe565f658996f93e8d65af2ad222d80b23aa08"
    sha256 cellar: :any, mojave:        "ee58ce5abf154406908cbc5104126d543ff47d62ae90319b4b7227726adb885b"
    sha256 cellar: :any, x86_64_linux:  "f73fdcd45d735133d54591aa4424fe860078d5ef2fedb49054e7b6697c203211" # linuxbrew-core
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "xmlto" => :build

  depends_on "libsodium"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable libunwind support due to pkg-config problem
    # https://github.com/Homebrew/homebrew-core/pull/35940#issuecomment-454177261

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-libsodium"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
    system "pkg-config", "libzmq", "--cflags"
    system "pkg-config", "libzmq", "--libs"
  end
end
