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
      sha256 "bb78fe316b6645834dd80ea4792341c2af5b22380ee7e79be6a55d6eac75f54f"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-amd64.tar.gz"
      sha256 "75dbdeb20e91f924045ccdcbff3461e3bd2e321c9a8277519d615bb5f662de08"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-arm64.tar.gz"
      sha256 "8bdf65a05e9a9215664034dd1e5d9075b9cba4e4a4c834e5a0eb74359c8d8d39"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-amd64.tar.gz"
      sha256 "52c986f44182068b1a2d1c9ec179671384631eb5fa5cd2061ba04aa4608ec310"
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
