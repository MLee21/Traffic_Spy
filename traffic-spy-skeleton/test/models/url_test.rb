require './test/test_helper'

class UrlTest < MiniTest::Test

  def test_create_full_url
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    full_url1 = TrafficSpy::Url.assemble_full_url(source1, "bacon", "cheese")
    assert_equal "http://yolo.com/bacon", full_url
    assert_equal "http://yolo.com/bacon/cheese", full_url1
  end

  def test_it_will_return_the_longest_response
    raw_payload1 = ('{"url":"http://yolo.com/bacon/cheese", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", "cheese")
    assert_equal 32, TrafficSpy::Url.longest_response_time(full_url)
  end

  def test_it_will_return_the_longest_response_time_for_a_url
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/steak", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload5)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload6)
    payload_creator.validate
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    assert_equal 35, TrafficSpy::Url.longest_response_time(full_url)
  end

  def test_it_will_return_the_shortest_response_time_for_a_url
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/steak", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload5)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload6)
    payload_creator.validate
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    assert_equal 20, TrafficSpy::Url.shortest_response_time(full_url)
  end

    def test_it_will_return_the_average_response_time_for_a_url
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/steak", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload5)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload6)
    payload_creator.validate
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    assert_equal 29.4, TrafficSpy::Url.average_response_time(full_url)
    end


    def test_it_will_return_the_http_verbs
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yourmom.com", "requestType":"POST", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/steak", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload5)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload6)
    payload_creator.validate
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    assert_equal ["GET", "POST"], TrafficSpy::Url.http_verbs(full_url)
    end


    def test_it_will_return_the_http_verbs
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yodaddy.com", "requestType":"POST", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/steak", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://craigslistbabydaddy.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload5)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload6)
    payload_creator.validate
    full_url = TrafficSpy::Url.assemble_full_url(source1, "bacon", nil)
    assert_equal "http://yourmom.com", TrafficSpy::Url.most_referred(full_url)
    end

    def test_it_will_return_the_most_popular_user_agents
    raw_payload1 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "BRO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chimera/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DONTEVEN", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "hansel", root_url: "http://hansel.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    full_url = TrafficSpy::Url.assemble_full_url(source1, "gymtime", nil)
    assert_equal "Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", TrafficSpy::Url.most_popular_user_agent(full_url)
    end
end
