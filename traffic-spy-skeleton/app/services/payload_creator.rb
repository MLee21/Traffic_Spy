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
        url:          Url.create(address: payload_hash["url"]),
        requested_at: payload_hash["requestedAt"],
        request_type: payload_hash["requestType"],
        responded_in: payload_hash["respondedIn"],
        source:       @source,
        event:        Event.create(name: payload_hash["eventName"]),
        resolution:   Resolution.create(resolution_height: payload_hash["resolutionHeight"], resolution_width: payload_hash["resolutionWidth"]),
        referral:     Referral.create(referred_by: payload_hash["referredBy"]),
        user_agent:   UserAgent.create(information: payload_hash["userAgent"]),
        ip:           Ip.create(address: payload_hash["ip"]),
        sha:          payload_hash[:sha]
        )
    end
  end
end


 #   byebug
      #   if Payload.exists?
      #     payload_creator = PayLoadCreator.new(@source, payload_attributes)
      #     payload_creator.create_payload
      #     @status = 200
      #     @body = "Payload created" 
      # # If the payload already exists
      # # FIX THIS
      # # test if sha is unique
      #   else payload_attributes[:sha].distinct
      #     @status = 403
      #     @body = "Forbidden: Request has already been received."     
    #     end
    #   end
    # end