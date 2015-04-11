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
    assert_equal 3, TrafficSpy::Source.url_index(source1[:id]).count
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

  def test_return_web_browsers_from_all_requests
    raw_payload1 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Firefox/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://hansel.com/bro", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "BRO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://hansel.com/comeatme", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DONTEVEN", "userAgent":"Safari/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')

    source1 = TrafficSpy::Source.create({identifier: "hansel", root_url: "http://hansel.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    assert_equal 3, TrafficSpy::Source.browser_index(source1[:id]).count
  end
end