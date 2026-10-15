# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.17.0"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.17.0/hydrate-v0.17.0-darwin-arm64.tar.gz"
      sha256 "819ebeb4dad67b962896244a48c6b43c0748ab5efe879bd7adb40db3dde0ff81"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.17.0/hydrate-v0.17.0-darwin-amd64.tar.gz"
      sha256 "aa8484e95825505c1f56a5316b7f02162069cfeb0e93dd0a3ba9dd008a117b26"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.17.0/hydrate-v0.17.0-linux-arm64.tar.gz"
      sha256 "c65a4ce262bcdd72a4d3cfafa44e969ab687ef6f769dcf12934cccf065b37d63"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.17.0/hydrate-v0.17.0-linux-amd64.tar.gz"
      sha256 "717a34147d85120219dd99aa487cf6c35ccc5f706b1d66f0af97b3927075311a"
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
