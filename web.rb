require 'sinatra/base'

module SlackWarrenbot
  class Web < Sinatra::Base
    get '/' do
      'Get to trading!'
    end
  end
end