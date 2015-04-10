require 'json'

module TrafficSpy
  class SourceBuilder 

  attr_accessor :status, :body

    def self.call(params)
      source = Source.new(identifier: params[:identifier],
                              root_url: params[:rootUrl])
      if source.save
        status 200
        {identifier: source.identifier}.to_json
      elsif Source.find_by(identifier: source.identifier)
        status 403
        body = source.errors.full_messages
      else
        status 400
        body = source.errors.full_messages
      end
    end 

    def self.status
      status
    end

    def self.body
      body
    end
  end
end