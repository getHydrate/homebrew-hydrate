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
      sha256 "f3da3c7adb96e61fb7162107182e77054f81a04837c402a4b3519aec37386dda"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-darwin-amd64.tar.gz"
      sha256 "a5ad5b9ce2aada137486be9374cb2a493e000acd24b5ca8c24e10e6bb2a7786b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-arm64.tar.gz"
      sha256 "c4dc2f50975a8894346216d9b4c4c392eba5baa63116325cbddbd3eed771fbc7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.5/hydrate-v0.4.5-linux-amd64.tar.gz"
      sha256 "bca6a3657a06f448d9dbfeaac77e583c227fa56bb650e2f4499d08bbe26d56ec"
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
