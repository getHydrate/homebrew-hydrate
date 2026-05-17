# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.4.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.4/hydrate-v0.4.4-darwin-arm64.tar.gz"
      sha256 "a94834514e22f1bd7339d459fa3f4ad57373fd1e686dc63a5e87fbd5739fc0a7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.4/hydrate-v0.4.4-darwin-amd64.tar.gz"
      sha256 "0cb3953288d24aa45e454c83ae8be91647b952bbcfc93448d023e63522cf94dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.4/hydrate-v0.4.4-linux-arm64.tar.gz"
      sha256 "02f3dc927600891eacbe1953365c2c6e1c6ed34cef4c1e52adea8c99e693b0ab"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.4.4/hydrate-v0.4.4-linux-amd64.tar.gz"
      sha256 "3b52643ffbb124a8037e1037a14b5897e983aedb39b3e1ec8c984cfe0edc6ebe"
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
