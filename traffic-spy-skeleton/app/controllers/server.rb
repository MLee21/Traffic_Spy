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
      payload = Source.create(params)
      if payload.save
         status 200
        "Source created"
      else
        status 400
        payload.errors.full_messages
      end
    end
  end
end