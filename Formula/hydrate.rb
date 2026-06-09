# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.6.8"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.8/hydrate-v0.6.8-darwin-arm64.tar.gz"
      sha256 "34f150b798564cd6641ea9519a1341d8a76a2d7247612ef00c2ffdb4613668ce"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.8/hydrate-v0.6.8-darwin-amd64.tar.gz"
      sha256 "d44eb54f17207f942f94aeae962276858e7e0a46fc813d0ba14cf1e90acb9915"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.8/hydrate-v0.6.8-linux-arm64.tar.gz"
      sha256 "88df1c6499cddef06b5d1853d1d766281269a1daf511f687f69d9df95762caf9"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.6.8/hydrate-v0.6.8-linux-amd64.tar.gz"
      sha256 "f2cd7b2cfa1e7c8c09fd6521f8a78dca0e414eab2e71a7118fdda5e27b3cacb7"
    end
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install "hydrate.vsix" if File.exist?("hydrate.vsix")
  end

  # Supervise hydrate-server via `brew services` so the daemon starts at login
  # and respawns on crash — the Homebrew-idiomatic equivalent of the launchd /
  # systemd units `hydrate server install` writes for non-brew installs. The
  # binary runs in the foreground here (brew/launchd is the supervisor); the
  # port is pinned so the managed instance always owns Hydrate's default port.
  # `hydrate setup` detects a brew install and defers to this rather than
  # writing a second, competing launchd agent.
  service do
    run [opt_bin/"hydrate-server"]
    keep_alive true
    environment_variables HYDRATE_PORT: "49849"
    log_path "#{Dir.home}/.hydrate/server.log"
    error_log_path "#{Dir.home}/.hydrate/server.log"
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
