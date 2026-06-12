# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.7.0"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.7.0/hydrate-v0.7.0-darwin-arm64.tar.gz"
      sha256 "c2a4d6503578a3784b8556881a12f5339c4314058b8a8648c3b00241a4075709"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.7.0/hydrate-v0.7.0-darwin-amd64.tar.gz"
      sha256 "81a3eacb8ed1a2ef53efd615dbe591036dd4cb90c5a5a87c4121a136daa18367"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.7.0/hydrate-v0.7.0-linux-arm64.tar.gz"
      sha256 "41d5150242edacc495ffcbb0cab0d9e2faa4a30932d242c3f99319311a01cf64"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.7.0/hydrate-v0.7.0-linux-amd64.tar.gz"
      sha256 "ab1987e5f7012ab1f9ffddc0f0130659c72ee48718eecf1a35bb37b8e7989c75"
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
