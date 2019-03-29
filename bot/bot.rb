require 'require_all'
require 'slack-ruby-bot'

require_all './bot/helpers/*.rb'
require_all './bot/commands/*.rb'

module Warren
  class Bot < SlackRubyBot::Bot

  	SlackRubyBot::Client.logger.level = Logger::WARN

    help do

      title 'warren'
      desc 'Interface with the stock market from slack'

      command 'quote' do
        desc 'Gets a quote for <ticker>'
        long_desc "To get a quote,\nsay '@warren quote <ticker>'"
      end
    end
  end
end