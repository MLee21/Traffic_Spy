require './test/test_helper'

class RetrieveComponentsforFullUrlTest < MiniTest::Test
  include Rack::Test::Methods

  def test_retrieve_full_url
    post '/sources', {identifier: "mustache", root_url: "http://mustache.gov"}
    raw_payload1 = ('{"url":"http://mustache.gov/wax", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://mustache.gov/wax", "requestedAt":"2018-03-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://mustache.gov/wax", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    post '/sources/mustache/data', raw_payload1
    post '/sources/mustache/data', raw_payload2
    post '/sources/mustache/data', raw_payload3

    get '/sources/mustache/urls/wax'
    TrafficSpy::Url.retrieve_root_url(source1[:id])
    assert_equal "mustache", last_response.body
  end       











end 