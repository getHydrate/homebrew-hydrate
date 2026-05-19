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
      sha256 "6f746d740b17f172e81c5b80bc2ca41bfcd31282f881ef8c4341c299c9d0a1e1"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-amd64.tar.gz"
      sha256 "cda0be0514b24fa38489e54da02d72580dddac1aebbe899e56175c8f5048fc55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-arm64.tar.gz"
      sha256 "37b3320455a5c01cb2f1632bdd634696b685220a12e086d388035998f3f65c22"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-amd64.tar.gz"
      sha256 "5360739b492ab151df8c2627f662696b0b463c278fa5d7dc26b85c17c52be21d"
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
