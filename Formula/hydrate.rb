class Hydrate < Formula
  desc "Memory layer for Claude Code — persistent context across sessions"
  homepage "https://gethydrate.dev"
  version "0.1.0-beta.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v#{version}/hydrate-darwin-arm64.tar.gz"
      sha256 "PLACEHOLDER_ARM64"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v#{version}/hydrate-darwin-amd64.tar.gz"
      sha256 "PLACEHOLDER_AMD64"
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
    assert_match version.to_s, shell_output("#{bin}/hydrate --version 2>&1", 0)
  end
end
