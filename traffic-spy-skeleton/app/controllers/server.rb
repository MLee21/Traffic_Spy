require 'byebug'

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
        else
          status 400
          source.errors.full_messages
        end
      end

    post '/sources/:identifier/data' do
      payload = Payload.create(params[:source])
      status 200
      "Payload created"
    end
  end
end