module Warren
  module Commands
    class Quote < SlackRubyBot::Commands::Base

      extend Warren::Helpers::Color
      extend Warren::Helpers::Queries
      extend Warren::Helpers::Stocks
      extend Warren::Helpers::Yahoo

      command 'quote' do |client, data, _match|
        begin
          query = _match['expression']
          puts "_match['expression']=#{query}"
          puts "data=#{data}"
          puts "match=#{_match}"
          client.say(channel: data.channel, text: ":mag_right: Looking up a quote for _#{query}_...")
          client.typing channel: data.channel

          names, options = parse_query(query)
          
          stocks = get_stocks names
          puts stocks
          if stocks.empty?
            client.say(channel: data.channel, text: ":cold_sweat: I couldn't find any quotes for #{query}")
            next
          end

          attachments = stocks.collect do |stock|
            options[:period] = "1d" 
            options[:interval] = "m" 
            {
              fallback: "#{stock.company_name} (#{stock.symbol}): $#{stock.latest_price}",
              title: "#{stock.company_name} (#{stock.symbol}) - #{stock.change.to_f > 0 ? ":chart_with_upwards_trend:" : ":chart_with_downwards_trend:"}",
              title_link: yahoo_profile(stock.symbol),
              #text: "#{stock.name} (#{stock.symbol}): $#{stock.last_trade_price_only}",
              #image_url: get_chart_url(stock.symbol, options),
              footer: stock.change.to_f > 0 ? ":megusta: ME GUSTA" : ":rageguy: Fffffffuuuuuuuuuuuu-",
              fields: [
                {
                    title: "Last Trade Price",
                    value: "$#{stock.latest_price}, #{stock.latest_time}",
                    short: true
                },
                {
                    title: "Change",
                    value: "$#{stock.change_percent}",
                    short: true
                },
                {
                    title: "High / Low",
                    value: "$#{stock.high} / $#{stock.low}",
                    short: true
                },
                {
                    title: "Vol / Avg Vol",
                    value: "#{(stock.latest_volume/1_000_000.00).round(2)}M / #{(stock.avg_total_volume/1_000_000.00).round(2)}M",
                    short: true
                },
                {
                    title: "Open / Previous Close",
                    value: "$#{stock.open} / $#{stock.previous_close}",
                    short: true
                }
              ],
              color: stock.change.to_f > 0 ? hex_color(:green) : hex_color(:red)
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


