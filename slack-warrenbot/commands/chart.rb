require 'stock_quote'
require 'color-generator'
require 'sec_query'
require_relative '../charts'
require_relative '../stocks'
require_relative '../queries'
require_relative '../yahoo'

module SlackWarrenbot
  module Commands

    class Chart < SlackRubyBot::Commands::Base
      command 'chart' do |client, data, _match|
        begin
          query = _match['expression']
          puts "_match['expression']=#{query}"
          names, options = Utilities::Queries.parse(query)
          stocks = Utilities::Stocks.get_stocks(names, options)
          if stocks.empty?
            client.say(channel: data.channel, text: "I couldn't find any charts for #{query}")
            next
          end
          attachments = []
          stocks.each do |stock|
            chart_url = Utilities::Charts.get_chart_url(stock.symbol, options)
            attachments << {
              fallback: "#{stock.name} (#{stock.symbol}): $#{chart_url}",
              title: "#{stock.name} (#{stock.symbol})",
              title_link: Utilities::Yahoo.get_profile_url(stock.symbol),
              image_url: chart_url,
              color: stock.change.to_f > 0 ? '#00FF00' : '#FF0000'
            }
          end
          client.web_client.chat_postMessage(channel: data.channel, text: "Here's what I found for #{query}", as_user: true, attachments: attachments)
        rescue => e
          client.say(channel: data.channel, text: "I couldn't process this request due to an error. Please check your query.")
          puts e
        end
      end
    end


  end
end