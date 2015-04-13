require './test/test_helper'
require 'tilt/erb'

class EventsFeaturesTest < Minitest::Test
 include Capybara::DSL
 include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    post '/sources', 'identifier=google&rootUrl=http://google.com'
    post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"POST","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    post '/sources/google/data', 'payload={"url":"http://google.com/blog/1","requestedAt":"2012-02-15 21:38:28 -0700","respondedIn":99,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
  end

  def test_events_index_page_without_valid_source
    visit '/sources/sincara/events'
    assert page.has_content?('No events have been defined')
  end

  def test_events_index_page_with_valid_source
    visit '/sources/google/events'
    assert page.has_content?("Most Received Event to Least Received Event")
  end

  def test_events_details_page
    visit '/sources/google/events/socialLogin'
    assert page.has_content?("event(s) at Hour:")
  end
end