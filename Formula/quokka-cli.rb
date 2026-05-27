class QuokkaCli < Formula
  desc "CLI to inspect and tidy an iPhone connected over USB to a Mac."
  homepage "https://github.com/dutradotdev/quokka"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dutradotdev/quokka/releases/download/v0.2.1/quokka-cli-aarch64-apple-darwin.tar.xz"
      sha256 "30359e7dc02d6fc839c6ffafcc7d26cfd6e80ebcd2427e8b00bf72781a70ea69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dutradotdev/quokka/releases/download/v0.2.1/quokka-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2becfba0343d88082ef365e87343dcaf30fe11b836270a8b1770510acb088df4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "qk", "quokka" if OS.mac? && Hardware::CPU.arm?
    bin.install "qk", "quokka" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
