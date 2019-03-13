require 'stock_quote'

module Warren
  module Helpers
    module Stocks

      def get_stocks names
        stocks = StockQuote::Stock.quote(names)
        return Array(stocks)
      end

    end
  end
end