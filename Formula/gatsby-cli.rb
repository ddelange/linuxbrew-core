require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.14.0.tgz"
  sha256 "6bc6740d9e610c8fa7f4da58cd3a0fb147a70e782f1aebdab6c29331396713d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33bb44eea9c8b817bad61cd5630dfaaa57eebf14eb9a304c381fe9f3dfcfed96"
    sha256 cellar: :any_skip_relocation, big_sur:       "30192f2c827360ed07282a103ec92628764d5f268e7fc33108919174f025e7c1"
    sha256 cellar: :any_skip_relocation, catalina:      "30192f2c827360ed07282a103ec92628764d5f268e7fc33108919174f025e7c1"
    sha256 cellar: :any_skip_relocation, mojave:        "30192f2c827360ed07282a103ec92628764d5f268e7fc33108919174f025e7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "964c1af311d8ab7aefb8086568433839f1dd39614b67f21af81291da2b72b499" # linuxbrew-core
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Avoid references to Homebrew shims
    rm_f libexec/"lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
