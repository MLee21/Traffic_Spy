require './test/test_helper'
require 'minitest/pride'

class CreatePayloadTest < MiniTest::Test 
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_create_a_payload
    source = Source.create({identifier: 'yes', rootURL: 'http://www.yes.com'})
    post '/sources/:identifier/data', {requested_at: "2013-02-16",
                                             request_type: "POST",
                                                responded_in: 37,
                                            source_id: source.id
    }
    assert_equal 1, Payload.count
    assert_equal 200, last_response.status
    assert_equal "Payload created", last_response.body
  end
end

