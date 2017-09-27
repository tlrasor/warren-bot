require 'stock_quote'
require 'color-generator'
require 'sec_query'

module SlackWarrenbot
    module Commands
        class Info < SlackRubyBot::Commands::Base

            @generator = ColorGenerator.new saturation: 0.75, lightness: 0.75

            command 'info' do |client, data, _match|
                n = _match['expression']
                symbols = StockQuote::Symbol.lookup(n)
                if(symbols.length < 1 )
                    client.say(channel: data.channel, text: "I couldn't find any info for company name or symbol '#{n}'")
                    next
                end
                attachmnts = []
                symbols.each do |symbol| 
                    begin
                        entity = SecQuery::Entity.find({:symbol=> symbol.symbol})
                    rescue
                        entity = SecQuery::Entity.new({})
                    end
                    attachmnts << {
                        fallback: "#{symbol.name} (#{symbol.symbol})",
                        title: "#{symbol.name} (#{symbol.symbol})",
                        title_link: "https://finance.yahoo.com/quote/#{symbol.symbol}",
                        fields: [
                            {
                                title: "Exchange and Type",
                                value: "#{symbol.exch_disp} - #{symbol.exch}\n #{symbol.type_disp} - #{symbol.type}",
                                short: true
                                
                            },
                            {
                                title: "SEC Info",
                                value: "CIK: <#{entity.cik_href}|#{entity.cik}>\n SIC: <#{entity.assigned_sic_href}|#{entity.assigned_sic}-#{entity.assigned_sic_desc}>",
                                short: true
                            }
                        ],
                        image_url: "https://finance.google.com/finance/getchart?q=#{symbol.symbol}",
                        color: "#{@generator.create_hex}",
                    }
                end
                client.web_client.chat_postMessage(
                    channel: data.channel,
                    as_user: true,
                    text: "Here's what I found for you for #{n}",
                    attachments: attachmnts
                )
            end
        end
    end
end

# #<StockQuote::Symbol:0x007fa4b5d6c7a0 
# @symbol="APPL", 
# @name="APPELL PETE CORP", 
# @exch="PNK", 
# @type="S", 
# @exch_disp="OTC Markets", 
# @type_disp="Equity">, #<StockQuote::Symbol:0x007fa4b5d65db0 @symbol="APGN.IR", @name="Applegreen Plc", @exch="ISE", @type="S", @exch_disp="Irish", @type_disp="Equity">,