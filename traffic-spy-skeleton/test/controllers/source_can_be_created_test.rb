require './test/test_helper'
require 'minitest/pride'

class CreateSourceTest < MiniTest::Test 
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_create_a_source
    post '/sources', {identifier: 'yes', rootURL: 'http://www.yes.com'}
    assert_equal 1, Source.count
    assert_equal 200, last_response.status
    assert_equal 'Source created', last_response.body
  end

  def test_cannot_create_source_without_identifier
    post '/sources', {identifier: '', rootURL: 'http://www.yes.com'}
    assert_equal 0, Source.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_cannot_create_source_without_root_url
    post '/sources', {identifier: 'yes', rootURL: ''}
    assert_equal 0, Source.count
    assert_equal 400, last_response.status
    assert_equal "Rooturl can't be blank", last_response.body
  end
end