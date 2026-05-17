# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.4.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.3/hydrate-v0.4.3-darwin-arm64.tar.gz"
      sha256 "f76a8278715b61ea492c8223fc76ce1636977e0adf0fa547faab37461b6a4a32"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.3/hydrate-v0.4.3-darwin-amd64.tar.gz"
      sha256 "056968e5a1c24d80c30feac2cf017f01fd57c33406934aac0bc3bcdce88b5699"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.3/hydrate-v0.4.3-linux-arm64.tar.gz"
      sha256 "74b10c5020e11eb13656436b5e8b01240bdea5edc73efaabaeb25ee8c187f574"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.3/hydrate-v0.4.3-linux-amd64.tar.gz"
      sha256 "f7b0a1d8560d7605f7f731b2f3f932e4c833272891bc9dc00c05cbb51e2d0d4c"
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
