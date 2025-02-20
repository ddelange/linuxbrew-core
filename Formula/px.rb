class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.5",
      revision: "489d1a9b53d184cd276a7f8ac4b2bb9eebbfdd59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb4a05f36cd35ee70beb27a8c48affd9a31faa395a2513e8b86814ea47548265"
    sha256 cellar: :any_skip_relocation, big_sur:       "528c083770ae2896f96d85fe83950805fb09dcde74ce3f4cbe71b276630719d8"
    sha256 cellar: :any_skip_relocation, catalina:      "a2611969d42994ea2104414b6b94369e4e5e6410264b58bfaf957f8721182cd2"
    sha256 cellar: :any_skip_relocation, mojave:        "a88a5da3ae0d63fa13b8b231d2a7ce1094a87d5ab36615daade6b2088311867c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c51e24b99500adc80d26477e652ee817bd5eec192378a6f2c0877d94247cdda"
  end

  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
