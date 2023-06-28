require_relative "test_helper"

class MapTest < Minitest::Test
  include Mapkick::Helper

  def setup
    @data = [{latitude: 1.23, longitude: 4.56}]
  end

  def test_js_map
    assert_map js_map(@data)
  end

  def test_area_map
    assert_map area_map([])
  end

  def test_escape_data
    bad_data = "</script><script>alert('xss')</script>"
    assert_match "\\u003cscript\\u003e", js_map(bad_data)
    refute_match "<script>alert", js_map(bad_data)
  end

  def test_escape_options
    bad_options = {xss: "</script><script>alert('xss')</script>"}
    assert_match "\\u003cscript\\u003e", js_map([], **bad_options)
    refute_match "<script>alert", js_map([], **bad_options)
  end

  def test_options_not_mutated
    options = {id: "boom"}
    js_map @data, **options
    assert_equal "boom", options[:id]
  end

  def test_id
    assert_match "id=\"test-id\"", js_map(@data, id: "test-id")
  end

  def test_id_escaped
    assert_match "id=\"test-123&quot;\"", js_map(@data, id: "test-123\"")
  end

  def test_height_pixels
    assert_match "height: 100px;", js_map(@data, height: "100px")
  end

  def test_height_percent
    assert_match "height: 100%;", js_map(@data, height: "100%")
  end

  def test_height_dot
    assert_match "height: 2.5rem;", js_map(@data, height: "2.5rem")
  end

  def test_height_quote
    error = assert_raises(ArgumentError) do
      js_map(@data, height: "150px\"")
    end
    assert_equal "Invalid height", error.message
  end

  def test_height_semicolon
    error = assert_raises(ArgumentError) do
      js_map(@data, height: "150px;background:123")
    end
    assert_equal "Invalid height", error.message
  end

  def test_width_pixels
    assert_match "width: 100px;", js_map(@data, width: "100px")
  end

  def test_width_percent
    assert_match "width: 100%;", js_map(@data, width: "100%")
  end

  def test_width_dot
    assert_match "width: 2.5rem;", js_map(@data, width: "2.5rem")
  end

  def test_width_quote
    error = assert_raises(ArgumentError) do
      js_map(@data, width: "80%\"")
    end
    assert_equal "Invalid width", error.message
  end

  def test_width_semicolon
    error = assert_raises(ArgumentError) do
      js_map(@data, width: "80%;background:123")
    end
    assert_equal "Invalid width", error.message
  end

  def test_loading
    assert_match ">Loading!!</div>", js_map(@data, loading: "Loading!!")
  end

  def test_loading_escaped
    assert_match "&lt;b&gt;Loading!!&lt;/b&gt;", js_map(@data, loading: "<b>Loading!!</b>")
    refute_match "<b>", js_map(@data, loading: "<b>Loading!!</b>")
  end

  def test_nonce
    assert_match "<script nonce=\"test-123\">", js_map(@data, nonce: "test-123")
  end

  def test_nonce_escaped
    assert_match "<script nonce=\"test-123&quot;\">", js_map(@data, nonce: "test-123\"")
  end

  def test_default_options
    Mapkick.options = {id: "test-123"}
    assert_match "id=\"test-123\"", js_map(@data)
  ensure
    Mapkick.options = OpenStruct.new
  end

  def test_default_options_by_block
    Mapkick.configure do |config|
      config.id = "test-123"
    end
    assert_match "id=\"test-123\"", js_map(@data)
  ensure
    Mapkick.options = OpenStruct.new
  end

  def test_map_ids
    @map_id = 0
    3.times do |i|
      assert_match "map-#{i + 1}", js_map(@data)
    end
  end

  def test_secret_token
    error = assert_raises(Mapkick::Error) do
      js_map(@data, access_token: "sk.token")
    end
    assert_equal "Expected public access token", error.message
  end

  def test_invalid_token
    error = assert_raises(Mapkick::Error) do
      js_map(@data, access_token: "token")
    end
    assert_equal "Invalid access token", error.message
  end

  def test_no_token
    refute_match "accessToken", js_map(@data)
  end

  private

  def assert_map(map)
    assert_match "new Mapkick", map
  end
end
