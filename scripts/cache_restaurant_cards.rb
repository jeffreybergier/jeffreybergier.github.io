#!/usr/bin/env ruby
# frozen_string_literal: true

require "cgi"
require "fileutils"
require "json"
require "net/http"
require "optparse"
require "time"
require "uri"
require "yaml"

ROOT_DIR = File.expand_path("..", __dir__)
SOURCE_DIR = File.join(ROOT_DIR, "source")

options = {
  input: File.join(SOURCE_DIR, "_data", "restaurants.yml"),
  output: File.join(SOURCE_DIR, "_data", "restaurant_cards.yml"),
  status: "love",
  refresh: false,
  quiet: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/cache_restaurant_cards.rb [options]"

  parser.on("--input PATH", "Restaurant YAML input") { |path| options[:input] = path }
  parser.on("--output PATH", "Card cache YAML output") { |path| options[:output] = path }
  parser.on("--status STATUS", "Restaurant status to cache") { |status| options[:status] = status }
  parser.on("--refresh", "Refetch existing cache entries") { options[:refresh] = true }
  parser.on("--quiet", "Only print warnings") { options[:quiet] = true }
end.parse!

def log(message, options)
  puts message unless options[:quiet]
end

def read_yaml(path, fallback)
  return fallback unless File.exist?(path)

  YAML.load_file(path) || fallback
end

def tabelog_url?(url)
  uri = URI.parse(url.to_s)
  uri.host == "tabelog.com" || uri.host&.end_with?(".tabelog.com")
rescue URI::InvalidURIError
  false
end

def fetch_html(url, limit = 3)
  raise "Too many redirects for #{url}" if limit <= 0

  uri = URI.parse(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "Mozilla/5.0 (compatible; jeffburg-restaurant-card-cache/1.0)"
  request["Accept-Language"] = "ja,en-US;q=0.8,en;q=0.6"

  response = Net::HTTP.start(
    uri.host,
    uri.port,
    use_ssl: uri.scheme == "https",
    open_timeout: 10,
    read_timeout: 20
  ) { |http| http.request(request) }

  case response
  when Net::HTTPSuccess
    response.body.force_encoding("UTF-8")
  when Net::HTTPRedirection
    fetch_html(URI.join(uri, response["location"]).to_s, limit - 1)
  else
    raise "HTTP #{response.code} for #{url}"
  end
end

def html_attr(tag, attr)
  tag[/\b#{Regexp.escape(attr)}\s*=\s*(['"])(.*?)\1/i, 2]
end

def meta_content(html, key)
  html.scan(/<meta\b[^>]*>/i).each do |tag|
    tag_key = html_attr(tag, "property") || html_attr(tag, "name")
    next unless tag_key == key

    content = html_attr(tag, "content")
    return CGI.unescapeHTML(content.to_s) if content
  end

  nil
end

def restaurant_jsonld_image(html)
  html.scan(%r{<script\b[^>]*type\s*=\s*(['"])application/ld\+json\1[^>]*>(.*?)</script>}mi).each do |_, raw_json|
    parsed = JSON.parse(raw_json.strip)
    candidates = parsed.is_a?(Array) ? parsed : [parsed]
    candidates.each do |candidate|
      next unless candidate.is_a?(Hash)

      type = candidate["@type"]
      types = type.is_a?(Array) ? type : [type]
      return candidate["image"] if types.include?("Restaurant") && candidate["image"]
    end
  rescue JSON::ParserError
    next
  end

  nil
end

def card_title(html, fallback)
  title = meta_content(html, "og:title").to_s.strip
  title = fallback if title.empty?
  title.sub(/\s+\([^)]*\)\z/, "")
end

restaurants = read_yaml(options[:input], [])
existing_cards = read_yaml(options[:output], [])
existing_by_id = existing_cards.each_with_object({}) do |card, lookup|
  lookup[card["id"]] = card if card.is_a?(Hash) && card["id"]
end

targets = restaurants.select do |restaurant|
  restaurant["status"] == options[:status] && tabelog_url?(restaurant["url"])
end

generated_cards = targets.filter_map do |restaurant|
  id = restaurant["id"]
  existing = existing_by_id[id]
  existing_current = existing &&
                     existing["source_url"] == restaurant["url"] &&
                     existing["title"].to_s != "" &&
                     existing["image"].to_s != ""

  if existing_current && !options[:refresh]
    log("Using cached card for #{restaurant["name"]}", options)
    next existing
  end

  begin
    log("Fetching card for #{restaurant["name"]}", options)
    html = fetch_html(restaurant["url"])
    image = restaurant_jsonld_image(html) || meta_content(html, "og:image")

    if image.to_s.empty?
      warn "No card image found for #{restaurant["name"]}"
      next existing
    end

    {
      "id" => id,
      "source_url" => restaurant["url"],
      "title" => card_title(html, restaurant["name"]),
      "image" => image,
      "cached_at" => Time.now.utc.iso8601
    }
  rescue StandardError => error
    warn "Could not cache #{restaurant["name"]}: #{error.message}"
    existing
  end
end

FileUtils.mkdir_p(File.dirname(options[:output]))
File.write(options[:output], "#{generated_cards.to_yaml}\n")
log("Wrote #{generated_cards.size} cards to #{options[:output]}", options)
