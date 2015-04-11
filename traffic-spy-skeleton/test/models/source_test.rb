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
    assert_equal true, TrafficSpy::Source.url_index(source1[:id]).any? {|x| x == "http://yolo.com/blog"}
    assert_equal true, TrafficSpy::Source.url_index(source1[:id]).any? {|x| x == "http://yolo.com/rolo"}
  end
end