# typed: false
# frozen_string_literal: true

# Hydrate — local-first persistent memory for Claude Code (and Codex, Mistral
# Vibe, MCP clients). Tap: getHydrate/hydrate
# Install: brew install getHydrate/hydrate/hydrate
class Hydrate < Formula
  desc "Local-first persistent memory for Claude Code, Codex, Vibe, and MCP"
  homepage "https://gethydrate.dev"
  version "0.8.0"
  # Hydrate is a commercial product distributed as signed binaries
  # under the Hydrate End User Licence Agreement (see LICENSE.txt
  # bundled in the release tarball). The Homebrew `license` field
  # accepts only SPDX identifiers for FOSS licences; :cannot_represent
  # is the Homebrew-spec way to declare a non-FOSS licence.
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.8.0/hydrate-v0.8.0-darwin-arm64.tar.gz"
      sha256 "e7491b053a44b826f6fc0533e4cf4092275e8227f03e54b103aa47dfbb6ec495"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.8.0/hydrate-v0.8.0-darwin-amd64.tar.gz"
      sha256 "21cd0b22309348163253d996cf76e87dd9ea978c53944b6a5b2b694314583f4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.8.0/hydrate-v0.8.0-linux-arm64.tar.gz"
      sha256 "777df1e89ecaa11168309090f37f7f690b765d594505b3e65dcc87bf37f3f018"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.8.0/hydrate-v0.8.0-linux-amd64.tar.gz"
      sha256 "03b1aad140884cdbc189396c51ae20ac76bcb6f93b0e641a1cce674348e4980a"
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
