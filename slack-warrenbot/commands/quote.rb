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
          client.say(channel: data.channel, text: ":mag_right: Looking up a quote for _#{query}_...")
          client.typing channel: data.channel
          names, options = parse_query(query)
          stocks = get_stocks(names, options)
          if stocks.empty?
            client.say(channel: data.channel, text: ":cold_sweat: I couldn't find any quotes for #{query}")
            next
          end

          attachments = []
          stocks.each do |stock|
            options[:period] = "1d" 
            options[:interval] = "m" 
            attachments << {
              fallback: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
              title: "#{stock.name} (#{stock.symbol}) - #{stock.change.to_f > 0 ? ":chart_with_upwards_trend:" : ":chart_with_downwards_trend:"}",
              title_link: get_yahoo_profile_url(stock.symbol),
              #text: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
              image_url: get_chart_url(stock.symbol, options),
              footer: stock.change.to_f > 0 ? ":megusta: ME GUSTA" : ":rageguy: Fffffffuuuuuuuuuuuu-",
              fields: [
                        {
                            title: "Last Trade",
                            value: "$#{stock.last_trade_price_only}, #{stock.last_trade_time}",
                            short: true
                        },
                        {
                            title: "Change",
                            value: "$#{stock.change_percent_change}",
                            short: true
                        },
                        {
                            title: "Bid / Ask",
                            value: "$#{stock.bid} / $#{stock.ask}",
                            short: true
                        },
                        {
                            title: "High / Low",
                            value: "$#{stock.days_high} / $#{stock.days_low}",
                            short: true
                        },
                        {
                            title: "Vol / Avg Vol",
                            value: "#{(stock.volume/1_000_000.00).round(2)}M / #{(stock.average_daily_volume/1_000_000.00).round(2)}M",
                            short: true
                        },
                        {
                            title: "Open / Previous Close",
                            value: "$#{stock.open} / $#{stock.previous_close}",
                            short: true
                        }
                      ],
              color: stock.change.to_f > 0 ? get_color(:green) : get_color(:red)
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


