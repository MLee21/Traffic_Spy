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
      source = Source.find_by(identifier: identifier)
      if params[:payload].blank?
        status 400
        "Payload is missing"
      elsif source.nil?
        status 403
        "Forbidden"
      else
        source
        payload_creator = PayloadCreator.new(source, params[:payload])
        payload_creator.create_payload
        status 200
        "Payload created"
      end
    end
  end
end