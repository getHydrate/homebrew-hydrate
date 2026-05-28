# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.1"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.1/hydrate-v0.6.1-darwin-arm64.tar.gz"
      sha256 "b9494f40fb6cbde676d69ba8f203019e16e625e863d6e0a20ddbe0c37f075c87"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.1/hydrate-v0.6.1-darwin-amd64.tar.gz"
      sha256 "8f91569bda1efa2fe1e0a87f1bd60fb6a37233938abb40a23c12bde5994760c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.1/hydrate-v0.6.1-linux-arm64.tar.gz"
      sha256 "eb29e642cc74678dd595a4379ee6dc08c1b77b10bc53b723767dc9976c11441d"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.1/hydrate-v0.6.1-linux-amd64.tar.gz"
      sha256 "194a704f7995a5b2c7c2259760806db7bcbcc987a67c91aab6d1de42aa7673f4"
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
