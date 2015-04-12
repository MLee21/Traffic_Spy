require './test/test_helper'

class RetrieveComponentsforFullUrlTest < MiniTest::Test
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

  def test_will_not_retrieve_url_stats_for_invalid_urls
    post '/sources', {identifier: "mustache", rootUrl: "http://mustache.gov"}
    raw_payload1 = '{"url":"http://mustache.gov/wax", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'
    raw_payload2 = '{"url":"http://mustache.gov/wax", "requestedAt":"2018-03-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"POST", "parameters":[], "eventName": "BOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'
    raw_payload3 = '{"url":"http://mustache.gov/wax", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":69, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'
    raw_payload4 = '{"url":"http://mustache.gov/wax/1", "requestedAt":"2013-03-15 21:1:28 -0700", "respondedIn":5, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}'

    post '/sources/mustache/data', 'payload' => raw_payload1
    post '/sources/mustache/data', 'payload' => raw_payload2
    post '/sources/mustache/data', 'payload' => raw_payload3
    post '/sources/mustache/data', 'payload' => raw_payload4


    get '/sources/mustache/urls/gerbils'
    assert_equal "Url has not been requested", last_response.body
  end

end
