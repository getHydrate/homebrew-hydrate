# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.11.0"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.0/hydrate-v0.11.0-darwin-arm64.tar.gz"
      sha256 "f573801ac0137b60c067bb307ae5bab5071f9eebcc9adc6fd6f9ac6dbe820a1a"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.0/hydrate-v0.11.0-darwin-amd64.tar.gz"
      sha256 "3537df5d83757ca27ff66f0bcf11d5a0021098002a3ed4c5de32a2d68042ccba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.0/hydrate-v0.11.0-linux-arm64.tar.gz"
      sha256 "b24801b900f69c711a7c4aaf240268cce2a04218f52ed16fe0b94b51e3ab7111"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.11.0/hydrate-v0.11.0-linux-amd64.tar.gz"
      sha256 "15e2b8ce9579f32c0039ea7ebea7b3aa5355fc15c4c0d050d901c553a748266a"
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
