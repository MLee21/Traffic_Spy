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

  def test_create_a_payload
    source = TrafficSpy::Source.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', 'payload' => '{ "url":"http://jumpstartlab.com/blog", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://jumpstartlab.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'
    
    payload1 = TrafficSpy::Payload.first
    assert_equal 1, TrafficSpy::Payload.count
    assert_equal Time.parse("2013-02-16 21:38:28 -0700"), payload1.requested_at
    assert_equal "http://jumpstartlab.com/blog", payload1.url.address
    assert_equal 37, payload1.responded_in
    assert_equal "http://jumpstartlab.com", payload1.referral.referred_by
    assert_equal "GET", payload1.request_type
    assert_equal "socialLogin", payload1.event.name
    assert_equal "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", payload1.user_agent.information
    assert_equal "1920", payload1.resolution.resolution_width
    assert_equal "1280", payload1.resolution.resolution_height
    assert_equal "63.29.38.211", payload1.ip.address
    assert_equal 200, last_response.status
    assert_equal "Payload created", last_response.body
  end

  def test_return_error_if_payload_is_missing
    source = TrafficSpy::Source.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data'

    assert_equal 400, last_response.status
    assert_equal "Payload is missing", last_response.body
  end

  def test_return_error_if_payload_is_empty
    source = TrafficSpy::Source.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', 'payload' => ''

    assert_equal 400, last_response.status
    assert_equal "Payload is missing", last_response.body
  end

  def test_return_error_if_payload_doesnt_exist
    source = TrafficSpy::Source.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', ''

    assert_equal 400, last_response.status
    assert_equal "Payload is missing", last_response.body
  end

  def test_return_error_if_request_payload_has_already_been_received
    source = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    post '/sources/yolo/data', 'payload' => '{ "url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'
    assert_equal true, TrafficSpy::Payload.exists?
    post '/sources/yolo/data', 'payload' => '{ "url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'
    
    assert_equal 403, last_response.status
    assert_equal "Forbidden: Request has already been received.", last_response.body
  end

  def test_if_url_doesnt_exist_application_not_registered
    post '/sources/bob/data', 'payload' => '{ "url":"http://jumpstartlab.com/blog", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://jumpstartlab.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'

    assert_equal 0, TrafficSpy::Payload.count
    assert_equal 403, last_response.status
    assert_equal "Forbidden: The url does not exist.", last_response.body
  end

  def test_if_identical_payloads_have_identical_shas
    raw_payload = ('{"url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload22 = TrafficSpy::PayloadCreator.new(source1, raw_payload)
    new_payload = payload22.create_payload
    assert_equal TrafficSpy::Payload.all.count, TrafficSpy::Payload.select(:sha).uniq.count
    assert_equal "cbf57c8f734c6f0f12d31faf7918a2ebdf978cd42529a109578ca7e1ed84cea4", new_payload[:sha]
  end
end

