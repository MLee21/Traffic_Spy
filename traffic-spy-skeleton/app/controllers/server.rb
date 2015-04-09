require 'byebug'
require 'json'
require 'digest'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      source = Source.new(identifier: params[:identifier],
                              root_url: params[:rootUrl])
        if source.save
          status 200
          {identifier: source.identifier}.to_json
        elsif Source.exists?(identifier: source.identifier)
          status 403
          source.errors.full_messages
        else
          status 400
          source.errors.full_messages
        end
      end

    post '/sources/:identifier/data' do |identifier|
      source = Source.find_by(identifier: identifier)
      # payload_creator = PayloadCreator.create(params[:payload], source)
      # status payload_creator.status
      # body payload_creator.body
      # pc = PayloadCreator.new(source, params)
      # parsed = pc.create_parsed_data
      source = Source.find_by(identifier: identifier)
      if params[:payload].blank?
        status 400
        "Payload is missing"
      elsif source.nil?
        status 403
        "Forbidden: The url does not exist."
      elsif Payload.exists?
     # elsif Payload.where[sha: sha]
        status 403
        "Forbidden: Request has already been received."
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