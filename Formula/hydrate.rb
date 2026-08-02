# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.12.1"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.12.1/hydrate-v0.12.1-darwin-arm64.tar.gz"
      sha256 "a9298dce91684316ee976de30594354ea2567b5d66d03569c30f2ad9d27d62b6"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.12.1/hydrate-v0.12.1-darwin-amd64.tar.gz"
      sha256 "048c640676fc58a592bca247f67775b1077742cd1914114f53bfc03e88914f55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.12.1/hydrate-v0.12.1-linux-arm64.tar.gz"
      sha256 "237d7fd47b8a2a5da265cb8aa3ec91dcd0bd03dadd4696b9ccd6ce80752dc06e"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.12.1/hydrate-v0.12.1-linux-amd64.tar.gz"
      sha256 "c212dbc646ecd351ca91654e73a4dac8c2969e807f2112d232ff0503b49dd178"
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
