# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.15.0"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.15.0/hydrate-v0.15.0-darwin-arm64.tar.gz"
      sha256 "5e911d73f260ca21503d4b9205077e51a57893f1538bfeaeec05786ad3bf216c"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.15.0/hydrate-v0.15.0-darwin-amd64.tar.gz"
      sha256 "f4fc35bbbd4b5312f97faaa36a602b07c50b1c2c6f5e4a8b9a294a9fafd336bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.15.0/hydrate-v0.15.0-linux-arm64.tar.gz"
      sha256 "4604f6cf15df9d62afa8186ed442e92a2f3e699b32a4e40de576a1fba2a90d5a"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.15.0/hydrate-v0.15.0-linux-amd64.tar.gz"
      sha256 "093e3b8f4c38aa6f75946d6d662f9b6a833772df1be47aabb2f071b6b222b126"
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
