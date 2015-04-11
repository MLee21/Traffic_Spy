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
    end

    
  end
end