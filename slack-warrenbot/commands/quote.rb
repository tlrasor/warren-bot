require 'stock_quote'
module SlackWarrenbot
  module Commands
    class Quote < SlackRubyBot::Commands::Base
	
  		@data_fields = ['Symbol', 'Name', 'Ask', 'ChangeinPercent','LastTradeDate','LastTradeTime', 'LastTradePriceOnly', 'Change']

      def self.get_image_url(symbol)
        return "https://finance.google.com/finance/getchart?q=#{symbol}&p=6M&i=86400"
        #return "http://stockcharts.com/c-sc/sc?s=#{symbol}&p=D&yr=0&mn=6&dy=0&id=p65897859777"
      end

  		command 'quote' do |client, data, _match|
        tickerSymbol = _match['expression']
        puts "_match['expression']=#{tickerSymbol}"
  			stock = StockQuote::Stock.quote(tickerSymbol, nil, nil, @data_fields)
        if stock.response_code == 404
          
          symbols = StockQuote::Symbol.lookup(tickerSymbol)
          if symbols.length < 1
            client.say(channel: data.channel, text: "I couldn't find that symbol or company name for you")
            next
          end
          client.say(channel: data.channel, text: "Could not find that symbol, but found similar company names")
          symbols.each do |symbol|
            s = symbol.symbol      
            stock = StockQuote::Stock.quote(s, nil, nil, @data_fields)
            client.web_client.chat_postMessage(
              channel: data.channel,
              as_user: true,
              attachments: [
                {
                  fallback: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
                  title: "#{stock.name} (#{stock.symbol})",
                  text: "$#{stock.last_trade_price_only} (#{stock.changein_percent})",
                  image_url: get_image_url(stock.symbol),
                  color: stock.change.to_f > 0 ? '#00FF00' : '#FF0000'
                }
              ]
            )
          end
          next
        end
        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [
            {
              fallback: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
              title: "#{stock.name} (#{stock.symbol})",
              text: "$#{stock.last_trade_price_only} (#{stock.changein_percent})",
              image_url: get_image_url(stock.symbol),
              color: stock.change.to_f > 0 ? '#00FF00' : '#FF0000'
            }
          ]
        )
      end
		end
  end
end