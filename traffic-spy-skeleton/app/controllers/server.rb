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
      sc = SourceCreator.new
      sc.raw_source(params[:identifier], params[:rootUrl]) 
      status sc.status
      sc.message
    end

    post '/sources/:identifier/data' do |identifier|
      source = Source.find_by(identifier: identifier)
      new_payload = PayloadCreator.new(source, params[:payload])
      new_payload.validate
      status new_payload.status
      new_payload.body
      # source = Source.find_by(identifier: identifier)
      # if params[:payload].blank?
      #   status 400
      #   "Payload is missing"
      # # if the payload has an empty url
      # # but payload is JSON
      # # parse it before checking for empty url
      # # elsif source.nil? 
      # elsif Payload.where(url: false) && source.nil?
      #   status 403
      #   "Forbidden: Application does not exist."
      # elsif Payload.exists?
      #   status 403
      #   "Forbidden: Request has already been received" 
      #   #payload must be created before checking for sha (save v. create)
      # else
      #   source
      #   payload_creator = PayloadCreator.new(source, params[:payload])
      #   payload_creator.create_payload
      #   status 200
      #   "Payload created"
      # end
    end
  end
end