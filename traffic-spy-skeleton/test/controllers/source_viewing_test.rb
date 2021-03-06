require './test/test_helper'
require 'byebug'
require 'minitest/pride'

class SourceControllerTest < MiniTest::Test 
  include Rack::Test::Methods

   def app
    TrafficSpy::Server
  end

  def test_it_works
    source = TrafficSpy::Source.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data', 'payload' => '{ "url":"http://jumpstartlab.com/blog", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://jumpstartlab.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'
    get '/sources/jumpstartlab'
    assert_equal true, true
  end
end