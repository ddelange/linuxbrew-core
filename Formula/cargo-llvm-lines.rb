class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.12.tar.gz"
  sha256 "4841e606a2fd642524b48206f5777691d7a66afad54ddea24cb4a3d63113484b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7477c0e478b44c685286fb5ee438991ba817308973f974b0105ac8f453d8f2c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "65a2750b5af50dc662e5015af0e86648af4258282bde5bef173edf5ee743bc8b"
    sha256 cellar: :any_skip_relocation, catalina:      "c7d2161ae1981fdab972e20cf41854a1db147dc51955bfe5f60de81fbdb14a19"
    sha256 cellar: :any_skip_relocation, mojave:        "2c964ba29b0a1d5f5c3d0bd6408a434acbe4f1f501319f8c92daf8caea219795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb066c9f466fac2bdf6fb293a7e531dcc4937a930ce417ef5bb622511a75341" # linuxbrew-core
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
