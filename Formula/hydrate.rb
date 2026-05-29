# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.6"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.6/hydrate-v0.6.6-darwin-arm64.tar.gz"
      sha256 "817fee937d39b647bd79373017a0b8d9bd790c090f2bc78ce8cda17e7b18df0c"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.6/hydrate-v0.6.6-darwin-amd64.tar.gz"
      sha256 "9a602ab3a0a0ae28c4e02c74d297b86f163f987b6dbe9c03d017164f7f5834f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.6/hydrate-v0.6.6-linux-arm64.tar.gz"
      sha256 "5f0b561d2aa7427f423ab31643d33f66fa3a60a843806f5d24aaaddcb8ca5314"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.6/hydrate-v0.6.6-linux-amd64.tar.gz"
      sha256 "96188fb7ab2cc70191fc48b65dfeed989ed93d94f32ec5323240f9b180826484"
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
