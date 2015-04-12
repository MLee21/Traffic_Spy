require 'byebug'
require 'json'
require 'digest'

module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      @sources = Source.all
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
      @source = Source.find_by(identifier: identifier)
      if @source.nil?
        "Identifer does not exist."
      else
        Source.url_index(@source.id)
        @urls = Source.most_requested_to_least_requested
        @paths = @urls.map {|url| URI(url).path}
        Source.browser_index(@source.id)
        @browsers = Source.browsers_from_index
        @platforms = Source.platforms_from_index
        @resolutions = Source.resolutions_index(@source.id)
        @response_times = Source.average_responses_per_url
        erb :application_data
      end
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
      @source = Source.find_by(identifier: identifier)
      if Event.events_by_frequency(@source.id).nil?
        "No events have been defined"
      else
        @events = Event.events_by_frequency(@source.id)
        erb :event
      end
    end

    get '/sources/:identifier/events/:name' do |identifier, name|
      @name = name
      @source = Source.find_by(identifier: identifier)
      @event_total = Event.event_total(name)
      @event_hours = Event.event_by_hour(name)
      erb :event_details
    end
  end
end
