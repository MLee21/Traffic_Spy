  class KeyPopulation

    def initialize(payload)
      @payload = payload
    end

    # this will find the source_id
    def self.create_source_id(identifier)
      Source.find_by(identifier: identifier).id
    end

    # create a payload
    def self.create_payload(params, identifier)
    Payload.create(
    payload = {  
    "requested_at" => params[:requested_at],
    "request_type" => params[:request_type],
    "responded_in" => params[:responded_in],
    "source_id"    => Source.find_by(identifier: identifier).id
        })
    end
  end
