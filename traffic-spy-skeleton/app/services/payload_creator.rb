module TrafficSpy
class PayloadCreator 

  def initialize(source, raw_payload)
    @source = source
    @raw_payload = raw_payload
  end

  # def self.create(payload_data, source)
  #   status = #some method to figure out the status
  #   body   = # a message based on the status or payload.errors.full_messages
  #   new(status, body)
  # end

  # attr_reader :status, :body

  # def initialize(status, body)
  #   @status = status
  #   @body   = body
  # end

  # def create_parsed_data
  #   JSON.parse(@raw_payload)
  # end

  def create_payload
    payload_attributes = JSON.parse(@raw_payload) 
    payload_attributes[:sha] = Digest::SHA2.hexdigest(@raw_payload)
    Payload.create!(
      url:          Url.create(address: payload_attributes["url"]),
      requested_at: payload_attributes["requestedAt"],
      request_type: payload_attributes["requestType"],
      responded_in: payload_attributes["respondedIn"],
      source:       @source,
      event:        Event.create(name: payload_attributes["eventName"]),
      resolution:   Resolution.create(resolution_height: payload_attributes["resolutionHeight"], resolution_width: payload_attributes["resolutionWidth"]),
      referral:     Referral.create(referred_by: payload_attributes["referredBy"]),
      user_agent:   UserAgent.create(information: payload_attributes["userAgent"]),
      ip:           Ip.create(address: payload_attributes["ip"]),
      sha:          payload_attributes[:sha]
    )
  end
end
end