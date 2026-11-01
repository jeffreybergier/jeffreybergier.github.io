#!/usr/bin/env ruby
# Run with Ruby 3.x; these tests never fetch restaurant pages.
require 'minitest/autorun'
require 'tmpdir'
require 'yaml'
require 'open3'
require 'rbconfig'

class RestaurantSnapshotTest < Minitest::Test
  SCRIPT = File.expand_path('cache_restaurant_cards.rb', __dir__)
  URL = 'https://tabelog.com/tokyo/A1301/A130101/12345678/'

  def setup
    @dir = Dir.mktmpdir('restaurant-snapshot')
    @input = File.join(@dir, 'restaurants.yml')
    @output = File.join(@dir, 'cards.yml')
    @restaurant = { 'url' => URL, 'status' => 'not_been', 'tags' => ['行きたい'] }
    @card = {
      'url' => URL, 'name' => 'Test restaurant', 'title' => 'Test restaurant',
      'addressRegion' => '東京都', 'addressLocality' => '中央区',
      'status' => 'love', 'chain' => true, 'urls' => ['https://example.com'],
      'tags' => ['old note']
    }
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def run_snapshot(cards)
    File.write(@input, [@restaurant].to_yaml)
    File.write(@output, cards.to_yaml)
    Open3.capture3(RbConfig.ruby, SCRIPT, '--offline', '--input', @input,
                  '--output', @output)
  end

  def test_valid_snapshot_uses_current_editorial_data
    _, stderr, result = run_snapshot([@card])
    assert result.success?, stderr
    card = YAML.load_file(@output).first
    assert_equal 'not_been', card['status']
    assert_equal ['行きたい'], card['tags']
    refute card.key?('chain')
    refute card.key?('urls')
    assert_equal 'Test restaurant', card['name']
  end

  def test_missing_card_fails_without_overwriting_snapshot
    _, stderr, result = run_snapshot([])
    refute result.success?
    assert_includes stderr, 'Missing restaurant metadata'
    assert_equal [].to_yaml, File.read(@output)
  end

  def test_url_only_fallback_is_rejected
    @card['name'] = URL
    @card['title'] = URL
    _, _, result = run_snapshot([@card])
    refute result.success?
    assert_equal [@card].to_yaml.b, File.binread(@output)
  end

  def test_missing_region_is_rejected
    @card.delete('addressRegion')
    _, _, result = run_snapshot([@card])
    refute result.success?
  end

  def test_removed_restaurants_are_not_kept
    other = Marshal.load(Marshal.dump(@card))
    other['url'] = URL.sub('12345678', '87654321')
    _, stderr, result = run_snapshot([@card, other])
    assert result.success?, stderr
    assert_equal [URL], YAML.load_file(@output).map { |card| card['url'] }
  end
end
