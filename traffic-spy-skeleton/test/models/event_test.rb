require './test/test_helper'

class EventTest < MiniTest::Test

  def test_events_from_most_received_to_least_received
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "GOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
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

    assert_equal "GOLO", TrafficSpy::Event.events_by_frequency(source1[:id]).last
    assert_equal "YOLO", TrafficSpy::Event.events_by_frequency(source1[:id]).first
  end

  def test_count_of_event_received_overall
    raw_payload1 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "YOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2014-02-25 21:38:28 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2013-03-15 21:38:28 -0700", "respondedIn":35, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://yolo.com/bacon", "requestedAt":"2012-04-15 21:38:28 -0700", "respondedIn":29, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "GOLO", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
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

    assert_equal 2, TrafficSpy::Event.event_total("DOLO")
    assert_equal 3, TrafficSpy::Event.event_total("YOLO")
  end

  def test_it_will_return_an_hour_by_hour_breakdown_of_when_a_event_is_received
    raw_payload1 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload2 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 04:12:32 -0700", "respondedIn":20, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chimera/24.0.1309.0 Safari/537.17", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload3 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-15 15:45:23 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "DONTEVEN", "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    raw_payload4 = ('{"url":"http://hansel.com/gymtime", "requestedAt":"2011-03-14 21:38:28 -0700", "respondedIn":32, "referredBy":"http://yourmom.com", "requestType":"GET", "parameters":[], "eventName": "Hansel", "userAgent":"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16", "resolutionWidth":"1920", "resolutionHeight":"1280", "ip":"62.23.37.212"}')
    
    source1 = TrafficSpy::Source.create({identifier: "hansel", root_url: "http://hansel.com"})
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload1)
    payload_creator.validate
  
    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload2)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload3)
    payload_creator.validate

    payload_creator = TrafficSpy::PayloadCreator.new(source1, raw_payload4)
    payload_creator.validate

    assert_equal [[3, 2],[10,1]], TrafficSpy::Event.event_by_hour("Hansel")
  end
end