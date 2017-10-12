require 'stock_quote'
require 'color-generator'
require 'sec_query'

module SlackWarrenbot
  module Commands
    class Info < SlackRubyBot::Commands::Base

      extend SlackWarrenbot::CommandHelper
      extend SlackWarrenbot::StocksHelper
      extend SlackWarrenbot::QueriesHelper

      @data_fields = ['Symbol', 'Name', 'Ask', 'ChangeinPercent','LastTradeDate','LastTradeTime', 'LastTradePriceOnly', 'Change']

      def self.get_image_url(symbol)
        return "https://finance.google.com/finance/getchart?q=#{symbol}&p=6M&i=86400"
        #return "http://stockcharts.com/c-sc/sc?s=#{symbol}&p=D&yr=0&mn=6&dy=0&id=p65897859777"
      end

      def self.get_title_link(symbol)
        return "https://finance.yahoo.com/quote/#{symbol}"
      end

      def self.post_quote(client, data, stock)
        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [
            {
              fallback: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
              title: "#{stock.name} (#{stock.symbol})",
              title_link: get_title_link(stock.symbol),
              text: "$#{stock.last_trade_price_only} (#{stock.changein_percent})",
              image_url: get_image_url(stock.symbol),
              color: stock.change.to_f > 0 ? '#00FF00' : '#FF0000'
            }
          ]
        )
      end  

      command 'info' do |client, data, _match|
        tickerSymbol = _match['expression']
        puts "_match['expression']=#{tickerSymbol}"
        stock = StockQuote::Stock.quote(tickerSymbol, nil, nil, @data_fields)
        if stock.failure?
          symbols = StockQuote::Symbol.lookup(tickerSymbol)
          if symbols.length < 1
            client.say(channel: data.channel, text: "I couldn't find that symbol or company name for you")
            next
          end
          client.say(channel: data.channel, text: "I could not find that symbol, but found these similarly named companies")
          symbols.each do |symbol|
            s = symbol.symbol      
            stock = StockQuote::Stock.quote(s, nil, nil, @data_fields)
            post_quote(client, data, stock)
          end
          next
        end
        post_quote(client, data, stock)
      end

      

    end
  end
end
