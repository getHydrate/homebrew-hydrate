class Hydrate < Formula
  desc "Memory layer for Claude Code - persistent context across sessions"
  homepage "https://gethydrate.dev"
  version "0.2.0-beta"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta/hydrate-darwin-arm64.tar.gz"
      sha256 "ef54884c272d2dbf1d427664bc4228839aba099845fb73ce0f18bc7b4ace7985"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta/hydrate-darwin-amd64.tar.gz"
      sha256 "969aad5eafca9f1a7ec5abf710375702e9c67b02912d316c2010a1b92c59ef91"
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
