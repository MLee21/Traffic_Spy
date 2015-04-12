module TrafficSpy
  class PayloadCreator 

    attr_accessor :status, :body, :source

    def initialize(source, raw_payload)
      @source = source
      @raw_payload = raw_payload
    end

    def validate
      if @source.nil?
        @status = 403
        @body = "Forbidden: Application does not exist."
      elsif @raw_payload.nil? || @raw_payload.empty?
        @status = 400
        @body = "Payload is missing"
      else 
        payload_attributes = JSON.parse(@raw_payload)
        payload_attributes[:sha] = Digest::SHA2.hexdigest(@raw_payload)
        if Payload.exists?(sha: payload_attributes[:sha])
          @status = 403
          @body = "Forbidden: Request has already been received."
        else
          create_payload(payload_attributes)
          @status = 200
          @body = "Payload created" 
        end
      end
    end

    def create_payload(payload_hash)
      Payload.create(
        url:          Url.find_or_create_by(address: payload_hash["url"]),
        requested_at: payload_hash["requestedAt"],
        request_type: payload_hash["requestType"],
        responded_in: payload_hash["respondedIn"],
        source:       @source,
        event:        Event.find_or_create_by(name: payload_hash["eventName"]),
        resolution:   Resolution.find_or_create_by(resolution_height: payload_hash["resolutionHeight"], resolution_width: payload_hash["resolutionWidth"]),
        referral:     Referral.find_or_create_by(referred_by: payload_hash["referredBy"]),
        user_agent:   UserAgent.find_or_create_by(information: payload_hash["userAgent"]),
        ip:           Ip.find_or_create_by(address: payload_hash["ip"]),
        sha:          payload_hash[:sha]
        )
    end
  end
end
