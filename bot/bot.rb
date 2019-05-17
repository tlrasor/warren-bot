require 'require_all'
require 'slack-ruby-bot'

require_all './bot/services/*.rb'

require_all './bot/hooks/*.rb'

require_relative './command'
require_all './bot/helpers/*.rb'
require_all './bot/commands/*.rb'

module Warren
  class Bot < SlackRubyBot::Bot

  	SlackRubyBot::Client.logger.level = Logger::WARN

    help do

      title 'warren'
      desc 'Interface with the stock market from slack'

      command 'quote' do
        desc 'Gets a quote for a given symbol'
        long_desc "To get a quote,\nsay '@warren quote symbol'"
      end
      command 'watch' do
        desc 'Adds a symbol to your watchlist'
        long_desc "To add a symbol to the watchlist,\nsay '@warren watch symbol'"
      end
      command 'watchlist' do
        desc 'Fetches your watchlist'
        long_desc "To see your watchlist,\nsay '@warren watchlist'"
      end
      command 'forget' do
        desc 'Removes a symbol from your watchlist'
        long_desc "To remove a symbol to the watchlist,\nsay '@warren forget symbol'"
      end
    end

    instance.on(:hello, Warren::Hooks::Scheduler.new)
    instance.on(:hello, Warren::Hooks::Hello.new)
  end
end