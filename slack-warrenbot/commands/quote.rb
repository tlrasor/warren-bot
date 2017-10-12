module SlackWarrenbot
  module Commands
    class Quote < SlackRubyBot::Commands::Base

      extend SlackWarrenbot::CommandHelper
      extend SlackWarrenbot::ChartsHelper
      extend SlackWarrenbot::StocksHelper
      extend SlackWarrenbot::QueriesHelper
      extend SlackWarrenbot::YahooHelper

      command 'quote' do |client, data, _match|
        begin
          query = _match['expression']
          puts "_match['expression']=#{query}"
          names, options = parse_query(query)
          stocks = get_stocks(names, options)
          if stocks.empty?
            client.say(channel: data.channel, text: "I couldn't find any quotes for #{query}")
            next
          end

          attachments = []
          stocks.each do |stock|
            options[:period] = "1d" unless options.key?(:period)
            options[:interval] = "m" unless options.key?(:interval)
            chart_url = get_chart_url(stock.symbol, options)
            client.web_client.chat_postMessage(
              channel: data.channel, 
              as_user: true, 
              text: make_text(stock)
            )
            # attachments << {
            #   fallback: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
            #   title: "#{stock.name} (#{stock.symbol})",
            #   title_link: Utilities::Yahoo.get_profile_url(stock.symbol),
            #   text: make_text(stock),
            #   image_url: chart_url,
            #   color: stock.change.to_f > 0 ? '#00FF00' : '#FF0000'
            # }
          end
          # client.web_client.chat_postMessage(channel: data.channel, as_user: true, attachments: attachments)
        rescue => e
          client.say(channel: data.channel, text: "I couldn't process this request due to an error. Please check your query.")
          puts e
        end
      end

      def self.make_text(stock)
        return """
        *#{stock.name} (#{stock.symbol})*
        \n*$#{stock.last_trade_price_only}* (#{stock.changein_percent}) 
        \n#{stock.volume}
        \n($#{stock.open}, $#{stock.days_high}, $#{stock.days_low})

        """
      end

		end
  end
end


