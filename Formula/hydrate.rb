# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.4"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.4/hydrate-v0.6.4-darwin-arm64.tar.gz"
      sha256 "874576c9ea81b154f73b67164eef98de0fa8a54c35381ed9ddae8710bbf3fd13"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.4/hydrate-v0.6.4-darwin-amd64.tar.gz"
      sha256 "a47fa840a7f13187d0303abf6f5367cab60a2c512f7cbebd9a52896c55175ea4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.4/hydrate-v0.6.4-linux-arm64.tar.gz"
      sha256 "f2ec9a4c903afe53481ce59e36fd11c2d658f8b43db9edace2505a99d8c3da99"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.4/hydrate-v0.6.4-linux-amd64.tar.gz"
      sha256 "9cf34e3b51f36e58d2de5b793f58a0b0d5a5d1af675b886fc12f8f5c288855fd"
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
