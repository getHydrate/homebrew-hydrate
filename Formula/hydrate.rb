# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.11.1"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.1/hydrate-v0.11.1-darwin-arm64.tar.gz"
      sha256 "e8b3090468eb50d7c123ed741dfc8e6eaef10658895632ebd01f321da73704b7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.1/hydrate-v0.11.1-darwin-amd64.tar.gz"
      sha256 "735b622a504743c52b26471e18772f63aa30deff5c5df99d68414e58c7a634a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.1/hydrate-v0.11.1-linux-arm64.tar.gz"
      sha256 "da65df9a9a0c54f9ba1eb3b9c5009f94d035d00dab5e6fbbe2d530184c7ac669"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.1/hydrate-v0.11.1-linux-amd64.tar.gz"
      sha256 "6c465925d3f099a4f2f6e22d45a1fe2160c8cd4eb528a99b626afa3238cf9d3d"
    end
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install "hydrate.vsix" if File.exist?("hydrate.vsix")
  end

  # Supervise hydrate-server via `brew services` so the daemon starts at login
  # and respawns on crash — the Homebrew-idiomatic equivalent of the launchd /
  # systemd units `hydrate server install` writes for non-brew installs. The
  # binary runs in the foreground here (brew/launchd is the supervisor).
  # Deliberately NO HYDRATE_PORT: pinning it flips the daemon onto the
  # explicit-port HOP branch and bypasses the D1 single-instance takeover, which
  # is what made the managed daemon split-brain the dashboard live feed. With no
  # HYDRATE_PORT the daemon takes the canonical path — it binds Hydrate's default
  # port or takes it over from a live incumbent via the authenticated handoff,
  # and never hops — which is how it "always owns the default port" correctly.
  # `hydrate setup` detects a brew install and defers to this rather than
  # writing a second, competing launchd agent.
  service do
    run [opt_bin/"hydrate-server"]
    keep_alive true
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
