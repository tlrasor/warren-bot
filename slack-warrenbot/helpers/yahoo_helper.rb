module SlackWarrenbot
  module YahooHelper

    def get_yahoo_profile_url(symbol)
      "https://finance.yahoo.com/quote/#{symbol}"
    end

  end

end