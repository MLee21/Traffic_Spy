module TrafficSpy
  class SourceCreator
    attr_reader :status, :message
    
    def raw_source(identifier, url)
      params = {identifier: identifier, root_url: url}
      if identifier.empty? || url.empty?
        @status = 400
        @message = Source.create(params).errors.full_messages
      elsif Source.exists?(identifier: identifier)
        @status = 403
        @message = Source.create(params).errors.full_messages
      else
        Source.create(params)
        @status = 200
        @message = {identifier: identifier}.to_json
      end
    end
  end
end