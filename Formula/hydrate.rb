# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code.
# Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code (and Codex)"
  homepage "https://gethydrate.dev"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.0/hydrate-v0.4.0-darwin-arm64.tar.gz"
      sha256 "e102ddbeab65b40a365a49d8e9e31cc52b8db40e547a7a759411e260db1ad8a8"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.0/hydrate-v0.4.0-darwin-amd64.tar.gz"
      sha256 "062e4d7288b861cbbb1c44628a2a3e515c2b501ef8f20412c7f5f875a23bb7c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.0/hydrate-v0.4.0-linux-arm64.tar.gz"
      sha256 "af4e098aaa18e22b1547cb2cfa40d78e7c9975a62477136a778ae6f0e842de0d"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.0/hydrate-v0.4.0-linux-amd64.tar.gz"
      sha256 "0c39aaa2bca05b33b6981b11b97c728501dbb99cac510f75c51b0c9e130ee174"
    end
  end

  def install
    bin.install Dir["bin/*"]
  end

  def caveats
    <<~EOS
      Quick start:
        hydrate setup           # interactive first-run: license, hooks, MCP, autostart
        hydrate doctor          # 16-point health check
        hydrate dashboard       # opens the local dashboard

      First-time onboarding form (license + project init + team git + import):
        https://gethydrate.dev/install/first-steps
    EOS
  end

  test do
    assert_match "hydrate", shell_output("#{bin}/hydrate version")
  end
end
