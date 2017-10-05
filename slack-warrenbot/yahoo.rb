module Utilities
  class Yahoo

    def self.get_profile_url(symbol)
      "https://finance.yahoo.com/quote/#{symbol}"
    end

  end

end