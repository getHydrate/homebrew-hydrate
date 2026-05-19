# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.4.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-arm64.tar.gz"
      sha256 "84c7eb23beb18f28565ba395e4d367da75185a08f4dd33ec47e6a69bbd33c11c"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-amd64.tar.gz"
      sha256 "8521ac152998991202d3a4f928581a26f6921abed98136613564a290b12a345d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-arm64.tar.gz"
      sha256 "c749e47f6c5bff9e35194ec8692a6a9bf5b15a069bd1f7929811be27febe7222"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-amd64.tar.gz"
      sha256 "ce4defa6dda067db39ea0b1f40c84c73f98003465853d65ed5f4247051340cf0"
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
