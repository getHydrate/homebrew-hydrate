class Hydrate < Formula
  desc "Memory layer for Claude Code - persistent context across sessions"
  homepage "https://gethydrate.dev"
  version "0.2.0-beta"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta/hydrate-darwin-arm64.tar.gz"
      sha256 "6f860326ea4516b851e5699f9ac00fb22c94ec651a8050de646802e9ca4361c3"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta/hydrate-darwin-amd64.tar.gz"
      sha256 "e34612694d32d8bc0e3f1821ab0c3967d2a8a234e5e38b14ffc21780d81fb24f"
    end
  end

  def install
    bin.install "hydrate"
    bin.install "hydrate-mcp"
    bin.install "hydrate-server"
    bin.install "claude-context"
    bin.install "claude-capture"
  end

  test do
    system "#{bin}/hydrate", "--version"
  end
end
