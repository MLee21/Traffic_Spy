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
      erb :index
    end

    post '/sources/:identifier/data' do |identifier|
      source = Source.find_by(identifier: identifier)
      new_payload = PayloadCreator.new(source, params[:payload])
      new_payload.validate
      status new_payload.status
      new_payload.body
    end

    get '/sources/:identifier' do |identifier|
      source = Source.find_by(identifier: identifier)
      if source.exists?
        # Source.most_requested_to_least_requested
        # Source.browsers_from_index
        # Source.platforms_from_index
        # Source.resolutions_index
        # Source.average_responses_per_url
      else
        "Identifier does not exist."
      end
      # create method that populates aggregate data
      # hyperlinks of each url to view url specific data
      # hyperlink to view aggregate event data
    end

    get '/sources/:identifier/urls/:relative/?:path?' do |identifier, relative, path|
      associated_source = Source.find_by(identifier: identifier)
      url = Url.assemble_full_url(associated_source, relative, path)
      if Url.requested?(url)
        @url_stats = Url.statistics(url)
        erb :url_stats
      else
        "Url has not been requested"
      end
    end


    get '/sources/:identifier/events' do |identifier|

    end
  end
end
