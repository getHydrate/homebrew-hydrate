# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.4.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.2/hydrate-v0.4.2-darwin-arm64.tar.gz"
      sha256 "ff117728f75ca6cdd30a605ad034ded09853385dbfb295cafbf5e7a28729d9d7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.2/hydrate-v0.4.2-darwin-amd64.tar.gz"
      sha256 "e6918fb7389e696c1975e992fe161f7a857b7044a069712433eec2373b25f248"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.2/hydrate-v0.4.2-linux-arm64.tar.gz"
      sha256 "2756b5fc2d9ba7b83961ee0545309111193cbbf6ea0d264a1ba9778e09dadd40"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.2/hydrate-v0.4.2-linux-amd64.tar.gz"
      sha256 "7032c5de734334d8203aee2b99d281e78e7a211362a930adeeb29764d2fc8b5c"
    end
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install "hydrate.vsix" if File.exist?("hydrate.vsix")
  end

  def caveats
    <<~EOS
      Quick start:
        hydrate setup           # interactive: license, hooks, MCP, autostart
        hydrate doctor          # health check
        hydrate register --edition=pro --email=you@example.com   # optional, locks $5/mo

      Docs:
        https://gethydrate.dev/docs/install
    EOS
  end

  test do
    assert_match "hydrate", shell_output("#{bin}/hydrate --version")
  end
end
