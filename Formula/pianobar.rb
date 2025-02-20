class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.11.28.tar.bz2"
  sha256 "653bfb96b548259e3ac360752f66fdb77e8e220312e52a43c652f7eb96e7d4fe"
  license "MIT"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "67d05332f2f15473c2a26d58ecc2d944cbc395be299bd0607fb73606f16469d3"
    sha256 cellar: :any,                 big_sur:       "e5db53d507cc120c3cd14d3cdf8ffe4c9084625262ebc493fd96f6202563d8c2"
    sha256 cellar: :any,                 catalina:      "7076f3d2b4415436821a42bbfebede61dd8a14525d6b0fecce540f9ee25b2bc3"
    sha256 cellar: :any,                 mojave:        "80ac5640ff018ca9a32c0739730e365eaf3c92b6a7f03848591e144b66c71361"
    sha256 cellar: :any,                 x86_64_linux:  "c3bfb49c3781f0815f2efd3de05cfd425ffce36650744d360f9a0af4d785f672" # linuxbrew-core
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    on_linux do
      # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
