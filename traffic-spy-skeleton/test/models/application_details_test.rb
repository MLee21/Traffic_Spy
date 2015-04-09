require './test/test_helper'
require 'minitest/pride'

class ApplicationDetailsTest < MiniTest::Test 
  include Rack::Test::Methods

  #include Capybara, don't need RACK test
  #Source.create, Payload.create setup

  def test_retrieve_all_urls_for_an_identifier
    post '/sources', 'identifier=jorge&rootURL=http://jorge.com'
    post '/sources/jorge/data', 'payload' => '{ "url":"http://jorge.com/george", "requestedAt":"2013-02-16 21:38:28 -0700", "respondedIn":37, "referredBy":"http://george.com", "requestType":"GET", "parameters":[], "eventName": "socialLogin", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"63.29.38.211"}'
    puts last_response.status
    post '/sources/jorge/data', 'payload' => '{ "url":"http://jorge.com/george", "requestedAt":"2015-03-16 21:38:28 -0700", "respondedIn":30, "referredBy":"http://sally.com", "requestType":"GET", "parameters":[], "eventName": "game", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"61.23.68.711"}'
    puts last_response.status
    assert_equal 2, Payload.all.count
    # we have a source identifier
    # get '/sources/jorge'
    # based off of that identifier, retrieve urls from payloads

    # expect count of urls
  end
end