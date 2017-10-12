require 'sec_query'

module SlackWarrenbot
    module Commands
        class Search < SlackRubyBot::Commands::Base

          extend SlackWarrenbot::CommandHelper
          extend SlackWarrenbot::StocksHelper
          extend SlackWarrenbot::SecHelper
          extend SlackWarrenbot::YahooHelper
          extend SlackWarrenbot::QueriesHelper

            command 'search' do |client, data, _match|
                query = _match['expression']
                puts "_match['expression']=#{query}"
                names, options = parse_query(query)
                symbols = get_symbols(names, options)
                if(symbols.length < 1 )
                    client.say(channel: data.channel, text: "I couldn't find any company names for '#{query}'")
                    next
                end
                attachmnts = []
                symbols.each do |symbol| 
                    entity = get_sec_entity(symbol.symbol)
                    attachmnts << {
                        fallback: "#{symbol.name} (#{symbol.symbol})",
                        title: "#{symbol.name} (#{symbol.symbol})",
                        title_link: get_yahoo_profile_url(symbol.symbol),
                        fields: [
                            {
                                value: ["Exchange - #{symbol.exch_disp} (#{symbol.exch})",
                                        "CIK - <#{entity.cik_href}|#{entity.cik}>",
                                        "SIC - <#{entity.assigned_sic_href}|#{entity.assigned_sic}-#{entity.assigned_sic_desc}>"
                                        
                                      ].join("\n"),
                                short: true
                            },
                            {
                                value: [
                                        "Type - #{symbol.type_disp} (#{symbol.type})",
                                        "State - <#{entity.state_location_href}|#{entity.state_location}>",

                                        ].join("\n"),
                                short: true
                            }
                        ],
                        color: "#{get_color}"
                    }
                end
                client.web_client.chat_postMessage(
                    channel: data.channel,
                    as_user: true,
                    text: "Here's what I found for #{query}",
                    attachments: attachmnts
                )
            end
        end
    end
end
