module SlackWarrenbot
  module Commands

    class Chart < SlackRubyBot::Commands::Base

      extend SlackWarrenbot::CommandHelper
      extend SlackWarrenbot::ChartsHelper
      extend SlackWarrenbot::StocksHelper
      extend SlackWarrenbot::QueriesHelper
      extend SlackWarrenbot::YahooHelper

      command 'chart' do |client, data, _match|
        begin
          query = _match['expression']
          puts "_match['expression']=#{query}"
          client.say(channel: data.channel, text: ":mag_right: Searching for _#{query}_...")
          client.typing channel: data.channel
          names, options = parse_query(query)
          stocks = get_stocks(names, options)
          if stocks.empty?
            client.say(channel: data.channel, text: ":cold_sweat: I couldn't find any charts for #{query}")
            next
          end
          attachments = []
          stocks.each do |stock|
            chart_url = get_chart_url(stock.symbol, options)
            attachments << {
              fallback: "#{stock.name} (#{stock.symbol}): $#{chart_url}",
              title: "#{stock.name} (#{stock.symbol})",
              title_link: get_yahoo_profile_url(stock.symbol),
              image_url: chart_url,
              color: "#{get_color(:blue)}"
            }
          end
          client.web_client.chat_postMessage(channel: data.channel, as_user: true, attachments: attachments)
        rescue => e
          client.say(channel: data.channel, text: "I couldn't process this request due to an error. Please check your query.")
          puts e
        end
      end
    end


  end
end