require './test/test_helper'

class SourceTest < MiniTest::Test 

  def test_source_has_urls
    raw_payload1 = ('{"url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/blog", "requestedAt":"2018-03-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    source2 = TrafficSpy::Source.where(identifier: 'yolo')
    assert_equal Array, TrafficSpy::Source.url_index(source1[:id]).class
    assert_equal 3, TrafficSpy::Source.all_url_addresses.count
  end

  def test_urls_are_ordered_from_most_to_least_requested
    raw_payload1 = ('{"url":"http://yolo.com/blog", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/blog", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload5 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2013-07-15 21:38:28 -0700", "respondedIn":31, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload6 = ('{"url":"http://yolo.com/solo", "requestedAt":"2013-09-15 21:38:28 -0700", "respondedIn":65, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    
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

    assert_equal 6, TrafficSpy::Source.url_index(source1[:id]).count
    assert_equal "http://yolo.com/rolo", TrafficSpy::Source.most_requested_to_least_requested.first
    assert_equal "http://yolo.com/solo", TrafficSpy::Source.most_requested_to_least_requested.last
  end

  def test_return_operations_systems_from_requests
    raw_payload1 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://hansel.com/bro", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "BRO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chimera/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://hansel.com/comeatme", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DONTEVEN", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "hansel", root_url: "http://hansel.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    TrafficSpy::Source.browser_index(source1[:id])
    assert_equal 3, TrafficSpy::Source.browser_index(source1[:id]).count
    assert_equal "X11", TrafficSpy::Source.platforms_from_index.first
  end

  def test_return_web_browsers_from_all_requests
    raw_payload1 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://hansel.com/bro", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "BRO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chimera/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://hansel.com/comeatme", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DONTEVEN", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "hansel", root_url: "http://hansel.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    TrafficSpy::Source.browser_index(source1[:id])
    assert_equal 3, TrafficSpy::Source.browser_index(source1[:id]).count
    assert_equal "Opera", TrafficSpy::Source.browsers_from_index.first
  end

  def test_source_has_screen_resolution_data
    raw_payload1 = ('{"url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1080", "resolutionHeight":"1100", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/blog", "requestedAt":"2018-03-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1120", "resolutionHeight":"1380", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1490", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    assert_equal 3, TrafficSpy::Source.resolutions_index(source1[:id]).count
    assert_equal ["1080", "1100"], TrafficSpy::Source.resolutions_index(source1[:id]).first
    assert_equal ["1490", "1280"], TrafficSpy::Source.resolutions_index(source1[:id]).last
  end

  def test_it_can_provide_average_response_time_per_url
    raw_payload1 = ('{"url":"http://yolo.com/blog", "requestedAt":"2015-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1080", "resolutionHeight":"1100", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/blog", "requestedAt":"2018-03-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1120", "resolutionHeight":"1380", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/rolo", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":10, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1490", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    source1 = TrafficSpy::Source.create({identifier: "yolo", root_url: "http://yolo.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate
    TrafficSpy::Source.url_index(source1[:id])

    assert_equal 2, TrafficSpy::Source.url_response_time.count
    assert_equal 26.0, TrafficSpy::Source.average_responses_per_url.first
  end
end