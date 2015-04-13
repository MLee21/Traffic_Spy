require './test/test_helper'

module TrafficSpy
  class ApplicationUrlStatisticsTest < MiniTest::Test
    include Rack::Test::Methods
    include Capybara::DSL

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

    def setup
      post '/sources', 'identifier=google&rootUrl=http://google.com'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":87,"referredBy":"http://google.com","requestType":"POST","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":37,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
      post '/sources/google/data', 'payload={"url":"http://google.com/blog/1","requestedAt":"2012-02-15 21:38:28 -0700","respondedIn":99,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    end

    def test_returns_error_if_url_does_not_exist
      visit '/sources/google/urls/soup'
      assert page.has_content?("Url has not been requested")
    end

    def test_client_can_navigate_to_url_specific_page
      visit '/sources/google/urls/blog'
      assert page.has_content?("Application URL Statistics")
    end

    def test_can_return_longest_response_time
      visit '/sources/google/urls/blog'
      assert page.has_content?(87)
    end

    def test_can_return_shortest_response_time
      visit '/sources/google/urls/blog'
      assert page.has_content?(37)
    end

    def test_shows_average_response_time
      visit '/sources/google/urls/blog'
      assert page.has_content?("Average Response Time")
      assert page.has_content?(62)
    end

    def test_shows_data_for_url_with_additional_path
      visit '/sources/google/urls/blog/1'
      assert page.has_content?("Application URL Statistics")
    end

    def test_shows_which_http_verbs_have_been_used
      visit '/sources/google/urls/blog'
      assert page.has_content?("POST")
    end

    def test_most_popular_referred_by
      visit '/sources/google/urls/blog'
      assert page.has_content?("http://google.com")
    end

    def test_most_popular_user_agents
      visit '/sources/google/urls/blog'
      assert page.has_content?("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    end

  end
end
