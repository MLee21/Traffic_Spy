require 'byebug'
require 'json'

module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      source = Source.create(params)
        if source.save
          status 200
          "Source created"
        elsif Source.exists?(identifier: source.identifier)
          status 403
          "Identifier already exists"
        else
          status 400
          source.errors.full_messages
        end
      end

    post '/sources/:identifier/data' do |identifier|
      source_id = Source.find_or_create_by(identifier: identifier).id
      hash = JSON.parse(params[:payload]) 
      Payload.create(
                  { requested_at: hash["requestedAt"],
                    request_type: hash["requestType"],
                    responded_in: hash["respondedIn"],
                    source_id: source_id
        }) 
      status 200
      "Payload created"
    end
  end
end