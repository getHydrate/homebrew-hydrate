# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.5"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.5/hydrate-v0.6.5-darwin-arm64.tar.gz"
      sha256 "c96487a4ee6b0671acd6dcd0adb0b97944c1cae06784a7ef49abae8f611076da"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.5/hydrate-v0.6.5-darwin-amd64.tar.gz"
      sha256 "0f75c3ee82a8a5144e9307fe6e3b42fe19ebc854f3f622c83c88486d7e295d24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.5/hydrate-v0.6.5-linux-arm64.tar.gz"
      sha256 "3f31c8dd6d36132f52fa393ba70bd3800b0ede92a50291c32111d3bcbdf0fe8d"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.5/hydrate-v0.6.5-linux-amd64.tar.gz"
      sha256 "ba5bf60e444224acf24da763166c41eb1a818d1dd4e8128b1601db9c3ac59098"
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
