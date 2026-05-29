# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.2"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.2/hydrate-v0.6.2-darwin-arm64.tar.gz"
      sha256 "8c706abda16dcf9e36523f5b6ad0fe64ccbb11583400efeef235ae8c6e35eb21"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.2/hydrate-v0.6.2-darwin-amd64.tar.gz"
      sha256 "453c85f103e9f8124b92249ccd01bda2f93a2fd33aa81b57bd69d53b13c8a1e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.2/hydrate-v0.6.2-linux-arm64.tar.gz"
      sha256 "f2f330d673928e1ae8d8d7286fb226550dc4457de9e6d8ce32fe8d78ac1e3e8e"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.2/hydrate-v0.6.2-linux-amd64.tar.gz"
      sha256 "3016bfd39fb52eace9516624a23b8f37e974104aa6cb4ede50b1893899ed6415"
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
