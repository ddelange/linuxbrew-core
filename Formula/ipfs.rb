class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.10.0",
      revision: "64b532fbb14145557dda7cb7986daea1e156f76d"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "976419cbae8a7d319812f22f21067bc3ed592d984d91e09a2a5eb6b92ec3c702"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c9e173c657f3286c06d0456c8f603b3c3a2f13664a960a7b62cf8f1e1aa253d"
    sha256 cellar: :any_skip_relocation, catalina:      "83669d4ead8a9837e27cb08abc146d9b61ebb39169744e02a1253a09bbf1e74d"
    sha256 cellar: :any_skip_relocation, mojave:        "2921ea76d75fc514b74c0230f8f2a7ea909a63d84543a03776e1dbbc50f35e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0696ffb55c2f637b06a2afc690c138c288d2b4d0954191d5825d0232f4b22bfc" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_output = Utils.safe_popen_read(bin/"ipfs", "commands", "completion", "bash")
    (bash_completion/"ipfs-completion.bash").write bash_output
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
