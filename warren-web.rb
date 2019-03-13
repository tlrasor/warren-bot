require 'sinatra/base'

module Warren
  class Web < Sinatra::Base
    get '/' do
      'Get to trading!'
    end
  end
end