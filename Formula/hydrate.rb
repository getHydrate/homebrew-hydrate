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
  version "0.2.0-beta.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta.1/hydrate-darwin-arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "4cb477af9e57a065663dfca344c2978f0b82ae7d94bd18381e2d7bd1294b2bd6"
    end
    on_intel do
      url "https://github.com/getHydrate/hydrate-public/releases/download/v0.2.0-beta.1/hydrate-darwin-amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "86f128c4fd3b891e1f97288146d9f58eda6c9ab0b15a460022e2cc2b8446e278"
    end
  end

  def install
    bin.install "hydrate"
    bin.install "hydrate-mcp"
    bin.install "hydrate-server"
    bin.install "claude-context"
    bin.install "claude-capture"
  end

  test do
    system "#{bin}/hydrate", "--version"
  end
end
