# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.3"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.3/hydrate-v0.6.3-darwin-arm64.tar.gz"
      sha256 "ba588140a61377ba69145f22eed90b1aa99ae9b53e5718934782c87d3c345723"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.3/hydrate-v0.6.3-darwin-amd64.tar.gz"
      sha256 "9ae51ae30060c02bc451837f89e9b57d0ddd86036db6bc0ab0177d9c2f240377"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.3/hydrate-v0.6.3-linux-arm64.tar.gz"
      sha256 "c7b3aa507449ea9829b4af467393c33f6c649fd723ea8c4e4d8c5ce986db9b7e"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.3/hydrate-v0.6.3-linux-amd64.tar.gz"
      sha256 "ca1e816dae96f78fab9a5d03be9c4aac1168efd633a6e7bd8dd69a180757f110"
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
