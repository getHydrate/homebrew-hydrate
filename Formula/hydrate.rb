class Hydrate < Formula
  desc "Memory layer for Claude Code - persistent context across sessions"
  homepage "https://gethydrate.dev"
  version "0.1.0-beta.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.1.0-beta.1/hydrate-darwin-arm64.tar.gz"
      sha256 "fb5f69883768823d1a1398f140e736a60a2ae499cee0759e3bb5c4add73e5493"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.1.0-beta.1/hydrate-darwin-amd64.tar.gz"
      sha256 "ec6d230dd6d7e672f0de4c1738e72055cf3ec3e62d27484926a1449dda958214"
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
