require './test/test_helper'
require 'byebug'
require 'minitest/pride'

class CreatePayloadTest < MiniTest::Test 
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

  def test_parse_JSON
    source = Source.create({identifier: "jumpstartlab", rootURL: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', 'payload' => '{ "url":"http://jumpstartlab.com/blog", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://jumpstartlab.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'

    payload1 = Payload.first
    assert_equal Time.parse("2013-02-16 21:38:28 -0700"), payload1.requested_at
    assert_equal 1, payload1.source_id
  end

  def test_create_a_payload
    source = Source.create({identifier: "jumpstartlab", rootURL: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', 'payload' => '{ "url":"http://jumpstartlab.com/blog", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://jumpstartlab.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'

    payload1 = Payload.first
    assert_equal 1, Payload.count
    assert_equal 1, payload1.source_id
    assert_equal 200, last_response.status
    assert_equal "Payload created", last_response.body
  end
end

