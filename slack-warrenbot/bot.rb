module SlackWarrenbot
  class Bot < SlackRubyBot::Bot

  	#SlackRubyBot::Client.logger.level = Logger::WARN

    help do

      title 'warren-bot'
      desc 'Interface with the stock market from slack'

      command 'quote' do
        desc 'Gets a quote for <ticker> from Yahoo Finance'
        long_desc "To get a quote,\nsay '@warren quote <ticker>'"
      end

      command 'chart' do
        desc 'Displays a simple price chart for <ticker> from Google Finance'
        long_desc ["To get a chart,",
                   "say '@warren chart <ticker>'",
                   "Options include:",
                   "period, changes the date range of the chart, ex '@warren chart <ticker> period=3M",
                   "interval, changes the interval of each data point, ex '@warrent chart <ticker> interval=w"
                  ].join("\n")
      end

      command 'info' do
        desc 'Gets company info for <message> from Yahoo Finance and the SEC'
        long_desc "To get company information,\nsay '@warren info <ticker>'"
      end

      command 'search' do
        desc 'Searches for companies based on company name using the SEC database'
        long_desc "To search for a company,\nsay '@warren search <company name>'"
      end
    end

  end
end