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

    get '/sources/:identifier' do |identifier|
      # if source = Source.find_by(identifier: identifier)
      #   # Source.most_requested_to_least_requested
      #   # Source.browsers_from_index
      #   # Source.platforms_from_index
      #   # Source.resolutions_index
      #   # Source.average_responses_per_url
      # else
      #   "Identifier does not exist."
      # end
      # create method that populates aggregate data
      # hyperlinks of each url to view url specific data
      # hyperlink to view aggregate event data
    end

    get '/sources/:identifier/urls/:relative/?:path?' do |identifier, relative, path| 
      source = Source.find_by(identifier: identifier)
       # assemble full url in URL class
       # go to payload and find response times
       # find longest, shortest, response times
       # http verbs
       # most popular referrals
       # most popular user agents
       # error if identifier doesn't exist
    end
  end
end