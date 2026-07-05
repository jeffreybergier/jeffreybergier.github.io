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

$stdout.sync = true
$stderr.sync = true

ROOT_DIR = File.expand_path("..", __dir__)
SOURCE_DIR = File.join(ROOT_DIR, "source")

options = {
  input: File.join(SOURCE_DIR, "_data", "restaurants.yml"),
  output: File.join(SOURCE_DIR, "_data", "restaurant_cards.yml"),
  status: nil,
  refresh: false,
  quiet: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/cache_restaurant_cards.rb [options]"

  parser.on("--input PATH", "Restaurant YAML input") { |path| options[:input] = path }
  parser.on("--output PATH", "Card cache YAML output") { |path| options[:output] = path }
  parser.on("--status STATUS", "Only cache a single restaurant status") { |status| options[:status] = status }
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

def restaurant_jsonld(html)
  html.scan(%r{<script\b[^>]*type\s*=\s*(['"])application/ld\+json\1[^>]*>(.*?)</script>}mi).each do |_, raw_json|
    parsed = JSON.parse(raw_json.strip)
    candidates = parsed.is_a?(Array) ? parsed : [parsed]
    candidates.each do |candidate|
      next unless candidate.is_a?(Hash)

      type = candidate["@type"]
      types = type.is_a?(Array) ? type : [type]
      return candidate if types.include?("Restaurant")
    end
  rescue JSON::ParserError
    next
  end

  {}
end

def image_url(value)
  case value
  when Array
    value.find { |item| item.to_s != "" }
  when Hash
    value["url"] || value["@id"]
  else
    value
  end
end

def card_title(html, fallback)
  title = meta_content(html, "og:title").to_s.strip
  title = fallback if title.empty?
  title.sub(/\s+\([^)]*\)\z/, "")
end

def area_from_title(html)
  title = meta_content(html, "og:title").to_s.strip
  match = title.match(/\s+\(([^\/)]+)\/[^)]*\)\z/)
  match && match[1]
end

def rating_value(jsonld)
  value = jsonld.dig("aggregateRating", "ratingValue").to_s.strip
  return nil if value.empty?

  Float(value)
rescue ArgumentError
  nil
end

def address_parts(jsonld)
  address = jsonld["address"]
  return {} unless address.is_a?(Hash)

  %w[addressRegion addressLocality streetAddress].each_with_object({}) do |key, parts|
    value = address[key].to_s.strip
    parts[key] = value unless value.empty?
  end
end

def address_text(parts)
  %w[addressRegion addressLocality streetAddress].filter_map { |key| parts[key] }.join
end

def short_description(html)
  description = meta_content(html, "description").to_s.strip
  return nil if description.empty?

  description = description.sub(/\A.*?の店舗情報は食べログでチェック！/m, "")
  description = description.sub(/口コミや評価.*\z/m, "")
  description = description.gsub(/\s+/, " ").strip
  return nil if description.empty?
  return nil if description.match?(/\A(?:【[^】]+】\s*)+\z/)

  max_length = 90
  description.length > max_length ? "#{description[0, max_length]}..." : description
end

def enriched_restaurant(restaurant, html)
  jsonld = restaurant_jsonld(html)
  title = card_title(html, restaurant["url"])
  name = jsonld["name"].to_s.strip
  name = title if name.empty?
  image = image_url(jsonld["image"]) || meta_content(html, "og:image")
  score = rating_value(jsonld)
  area = area_from_title(html)
  address_parts = address_parts(jsonld)
  address = address_text(address_parts)
  description = short_description(html)

  enriched = {}
  %w[url status chain urls tags].each do |key|
    enriched[key] = restaurant[key] if restaurant.key?(key)
  end

  enriched["source_url"] = restaurant["url"]
  enriched["name"] = name
  enriched["title"] = title
  enriched["image"] = image if image.to_s != ""
  enriched["tabelog_score"] = score if score
  enriched["area"] = area if area.to_s != ""
  enriched["cuisine"] = jsonld["servesCuisine"] if jsonld["servesCuisine"].to_s != ""
  enriched["description"] = description if description.to_s != ""
  enriched["price_range"] = jsonld["priceRange"] if jsonld["priceRange"].to_s != ""
  %w[addressRegion addressLocality streetAddress].each do |key|
    enriched[key] = address_parts[key] if address_parts[key].to_s != ""
  end
  enriched["address"] = address if address.to_s != ""
  enriched["telephone"] = jsonld["telephone"] if jsonld["telephone"].to_s != ""
  enriched["cached_at"] = Time.now.utc.iso8601
  enriched
end

restaurants = read_yaml(options[:input], [])
existing_cards = read_yaml(options[:output], [])
existing_by_url = existing_cards.each_with_object({}) do |card, lookup|
  next unless card.is_a?(Hash)

  url = card["url"] || card["source_url"]
  lookup[url] = card if url
end

targets = restaurants.select do |restaurant|
  (options[:status].nil? || restaurant["status"] == options[:status]) &&
    tabelog_url?(restaurant["url"])
end
log("Caching #{targets.size} restaurants", options)

generated_cards = targets.each_with_index.filter_map do |restaurant, index|
  url = restaurant["url"]
  existing = existing_by_url[url]
  existing_current = existing &&
                     existing["url"] == url &&
                     existing["name"].to_s != "" &&
                     existing["title"].to_s != "" &&
                     existing["area"].to_s != "" &&
                     existing["cuisine"].to_s != "" &&
                     existing["addressRegion"].to_s != "" &&
                     existing["addressLocality"].to_s != "" &&
                     existing["streetAddress"].to_s != "" &&
                     existing["description"].to_s != ""

  if existing_current && !options[:refresh]
    log("Using cached data for #{existing["name"]}", options)
    next existing
  end

  begin
    log("Fetching data #{index + 1}/#{targets.size}: #{url}", options)
    html = fetch_html(url)
    enriched_restaurant(restaurant, html)
  rescue StandardError => error
    warn "Could not cache #{url}: #{error.message}"
    existing || restaurant.merge(
      "source_url" => url,
      "name" => url,
      "title" => url,
      "cached_at" => Time.now.utc.iso8601
    )
  end
end

FileUtils.mkdir_p(File.dirname(options[:output]))
File.write(options[:output], "#{generated_cards.to_yaml}\n")
log("Wrote #{generated_cards.size} cards to #{options[:output]}", options)
