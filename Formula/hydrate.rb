# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.5.1"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.5.1/hydrate-v0.5.1-darwin-arm64.tar.gz"
      sha256 "47050946eddd11c452643b99cdd078a87b801ca7fd566c0971f549cef1de478a"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.5.1/hydrate-v0.5.1-darwin-amd64.tar.gz"
      sha256 "393f24a2971206be3c83b4ce734acaf928ba45acff607378bfe97b25836aeef9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.5.1/hydrate-v0.5.1-linux-arm64.tar.gz"
      sha256 "50636bddf28feb3cb688fb09c5dd697cc167499f8786ee76a75f1f483b667c28"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.5.1/hydrate-v0.5.1-linux-amd64.tar.gz"
      sha256 "f623b31e228e3ea451f8ec9280fac91bec32199d22d5c49d2a80126d3865aeae"
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
