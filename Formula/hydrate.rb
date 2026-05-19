# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.4.5"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-arm64.tar.gz"
      sha256 "3e0e6fa795692f93fd7db31a80c1b4889bd1316d8285f94497544099503f73c7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-amd64.tar.gz"
      sha256 "12d7e2e46d9bf7a0da54b6ec9ab5f2282b4fc1e9f34959ca872486ec4cc80efe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-arm64.tar.gz"
      sha256 "b79fbf6a193f58564287e3c7fe061ae11a2b658e1ba30ca86c245954a4144da2"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-amd64.tar.gz"
      sha256 "6711ae3b4e9c7b1bc7575dfbff4ed74866cc4758eedd873c4b5e1da5b9115f89"
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
