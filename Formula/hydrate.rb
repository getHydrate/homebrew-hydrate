require "download_strategy"
require "json"

# GitHubPrivateRepositoryReleaseDownloadStrategy — fetches release assets from
# a private GitHub repo by resolving the release-tag URL to the asset's API
# endpoint and authenticating with HOMEBREW_GITHUB_API_TOKEN.
#
# Beta testers must export HOMEBREW_GITHUB_API_TOKEN with `repo` scope (a
# fine-grained PAT scoped to getHydrate/hydrate-public is enough). The
# Authorization header is only attached to api.github.com requests, so the
# token never leaks to other hosts.
class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
  end

  def parse_url_pattern
    pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    match = @url.match(pattern)
    raise CurlDownloadStrategyError, "Invalid GitHub release URL: #{@url}" unless match
    @owner, @repo, @tag, @filename = match.captures
  end

  def github_token
    @github_token ||= begin
      token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
      if token.nil? || token.empty?
        raise CurlDownloadStrategyError, <<~EOS
          HOMEBREW_GITHUB_API_TOKEN must be set with `repo` scope to install hydrate
          from the private #{@owner}/#{@repo} release.

          Create a token at https://github.com/settings/personal-access-tokens/new
          with read access to #{@owner}/#{@repo}, then:

            export HOMEBREW_GITHUB_API_TOKEN="ghp_yourtokenhere"
        EOS
      end
      token
    end
  end

  def asset_id
    @asset_id ||= begin
      release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
      json = curl_output(
        "--header", "Authorization: token #{github_token}",
        "--header", "Accept: application/vnd.github+json",
        "--silent", "--fail", "--location",
        release_url,
      ).stdout
      release = JSON.parse(json)
      asset = release.fetch("assets", []).find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "Asset #{@filename} not found in #{@owner}/#{@repo}@#{@tag}" if asset.nil?
      asset["id"]
    end
  end

  def _fetch(url:, resolved_url:, timeout:)
    api_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
    curl_download(
      "--header", "Authorization: token #{github_token}",
      "--header", "Accept: application/octet-stream",
      api_url,
      to: temporary_path,
      timeout: timeout,
    )
  end
end

class Hydrate < Formula
  desc "Memory layer for Claude Code - persistent context across sessions"
  homepage "https://gethydrate.dev"
  version "0.2.0-beta.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta.3/hydrate-darwin-arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "3c1f4bf5a0c023cb9a5218b0b4c40cfdb2cc7fa7ba59c5c345282d3423fe96a7"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta.3/hydrate-darwin-amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "a15ef5f705dcd6196600e4c5ab521f74ff8ecc86d05445cae1d2cc17cb8347b0"
    end
  end

  def install
    bin.install "hydrate"
    bin.install "hydrate-mcp"
    bin.install "hydrate-server"
    bin.install "claude-context"
    bin.install "claude-capture"
    # Bundled VS Code extension — `hydrate install-vscode` looks here.
    pkgshare.install "hydrate.vsix" if File.exist?("hydrate.vsix")
  end

  def caveats
    <<~EOS
      To finish installing Hydrate, wire the Claude Code hooks
      (one-time after install, plus after each `brew upgrade hydrate`
      to refresh the embedded slash command templates):

          hydrate install-hooks

      Then install the VS Code extension (optional, but recommended
      if you use VS Code with GitHub Copilot):

          hydrate install-vscode

      For Sedasoft enterprise users, register against the server:

          hydrate enterprise install --config=./sedasoft-enterprise-config.json

      Restart any open Claude Code sessions after `install-hooks`
      so they pick up the new settings.
    EOS
  end

  test do
    system "#{bin}/hydrate", "--version"
  end
end
