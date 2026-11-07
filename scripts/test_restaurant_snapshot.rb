#!/usr/bin/env ruby
# Run with Ruby 3.x; these tests never fetch restaurant pages.
require 'minitest/autorun'
require 'tmpdir'
require 'yaml'
require 'date'
require 'open3'
require 'rbconfig'

class RestaurantSnapshotTest < Minitest::Test
  SCRIPT = File.expand_path('cache_restaurant_cards.rb', __dir__)
  URL = 'https://tabelog.com/tokyo/A1301/A130101/12345678/'

  def setup
    @dir = Dir.mktmpdir('restaurant-snapshot')
    @input = File.join(@dir, 'restaurants.yml')
    @output = File.join(@dir, 'cards.yml')
    @restaurant = { 'url' => URL, 'dateAdded' => '2026-06-21',
                    'status' => 'not_been', 'tags' => ['行きたい'] }
    @card = {
      'url' => URL, 'name' => 'Test restaurant', 'title' => 'Test restaurant',
      'addressRegion' => '東京都', 'addressLocality' => '中央区',
      'status' => 'love', 'chain' => true, 'urls' => ['https://example.com'],
      'tags' => ['old note'], 'dateAdded' => '2026-11-01',
      'cached_at' => '2026-11-05T04:34:41Z'
    }
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def run_snapshot(cards, mode: '--offline', env: {})
    File.write(@input, [@restaurant].to_yaml)
    File.write(@output, cards.to_yaml)
    Open3.capture3(env, RbConfig.ruby, SCRIPT, mode, '--input', @input,
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
    assert_equal '2026-06-21', card['dateAdded']
    assert_equal @card['cached_at'], card['cached_at']
    before = File.binread(@output)
    _, stderr, result = run_snapshot([card])
    assert result.success?, stderr
    assert_equal before, File.binread(@output), 'Offline regeneration is idempotent'
  end

  def test_missing_date_is_rejected_without_overwriting_snapshot
    @restaurant.delete('dateAdded')
    _, stderr, result = run_snapshot([@card])
    refute result.success?
    assert_includes stderr, 'Invalid or missing dateAdded'
    assert_equal [@card].to_yaml.b, File.binread(@output)
  end

  def test_invalid_dates_are_rejected
    ['', '2026-6-21', '2026-02-30', 'not a date', 20260621, '2026-06-21T00:00:00Z'].each do |date|
      @restaurant['dateAdded'] = date
      _, stderr, result = run_snapshot([@card])
      refute result.success?, date.inspect
      assert_includes stderr, 'dateAdded'
      assert_equal [@card].to_yaml.b, File.binread(@output)
    end
  end

  def test_refresh_preserves_editorial_date_instead_of_fetch_date
    stub = File.join(@dir, 'http_stub.rb')
    File.write(stub, <<~RUBY)
      require 'net/http'
      Net::HTTP.define_singleton_method(:start) do |*args|
        response = Net::HTTPOK.new('1.1', '200', 'OK')
        response.instance_variable_set(:@read, true)
        response.body = '<meta property="og:title" content="Refreshed restaurant">'
        response
      end
    RUBY
    _, stderr, result = run_snapshot([@card], mode: '--refresh', env: { 'RUBYOPT' => "-r#{stub}" })
    assert result.success?, stderr
    card = YAML.load_file(@output).first
    assert_equal 'Refreshed restaurant', card['name']
    assert_equal @restaurant['dateAdded'], card['dateAdded']
    refute_equal @card['cached_at'], card['cached_at']
  end

  def test_failed_refresh_preserves_editorial_date
    stub = File.join(@dir, 'http_failure.rb')
    File.write(stub, "require 'net/http'\nNet::HTTP.define_singleton_method(:start) { |*args| raise 'offline test' }\n")
    _, stderr, result = run_snapshot([@card], mode: '--refresh', env: { 'RUBYOPT' => "-r#{stub}" })
    assert result.success?, stderr
    assert_includes stderr, 'offline test'
    card = YAML.load_file(@output).first
    assert_equal @restaurant['dateAdded'], card['dateAdded']
    assert_equal @card['cached_at'], card['cached_at']
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

  def test_checked_in_dates_are_valid_and_synced
    data = File.expand_path('../source/_data', __dir__)
    restaurants = YAML.load_file(File.join(data, 'restaurants.yml'))
    cards = YAML.load_file(File.join(data, 'restaurant_cards.yml'))
    dates = restaurants.to_h { |restaurant| [restaurant['url'], restaurant['dateAdded']] }
    assert_equal restaurants.length, dates.length, 'Restaurant URLs must be unique'
    dates.each_value do |date|
      assert_match(/\A\d{4}-\d{2}-\d{2}\z/, date)
      assert_equal date, Date.iso8601(date).iso8601
    end
    assert_equal dates, cards.to_h { |card| [card['url'], card['dateAdded']] }
  end

  def test_removed_restaurants_are_not_kept
    other = Marshal.load(Marshal.dump(@card))
    other['url'] = URL.sub('12345678', '87654321')
    _, stderr, result = run_snapshot([@card, other])
    assert result.success?, stderr
    assert_equal [URL], YAML.load_file(@output).map { |card| card['url'] }
  end
end
