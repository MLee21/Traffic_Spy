class PayloadCreator 

  def initialize(source, payload)
    @source = source
    @payload = payload
  end

  def create_payload
    hash = JSON.parse(@payload) 
    Payload.create!(
      url:          Url.create(address: hash["url"]),
      requested_at: hash["requestedAt"],
      request_type: hash["requestType"],
      responded_in: hash["respondedIn"],
      source:       @source,
      event:        Event.create(name: hash["eventName"]),
      resolution:   Resolution.create(resolution_height: hash["resolutionHeight"], resolution_width: hash["resolutionWidth"]),
      referral:     Referral.create(referred_by: hash["referredBy"]),
      user_agent:   UserAgent.create(information: hash["userAgent"]),
      ip:           Ip.create(address: hash["ip"])
    )
  end
end