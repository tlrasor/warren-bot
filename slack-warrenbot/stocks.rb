require 'stock_quote'

module Utilities
  class Stocks

    EXCHANGES = ['NYQ', 'NAS']
    DATA_FIELDS = ['Symbol', 'Name', 'Ask', 'ChangeinPercent','LastTradeDate','LastTradeTime', 'LastTradePriceOnly', 'Change']
    OPTIONS = { :limit => 3 }

    def self._get_symbols_for_name(name, exchanges)
      symbols = StockQuote::Symbol.lookup(name)
      if symbols.empty?
        puts "Unable to find any symbols or company names for #{name} on the #{exchanges} exchanges."
        return []
      end
      
      exact_match  = symbols.find {|s| s.symbol.casecmp(name) == 0 }
      return [ exact_match.symbol ] unless exact_match.nil?
      
      puts "Unable to find exact match for #{name}"
      return symbols.map { |s| s.symbol }

    end

    def self._handle_name(name, options, exchanges, data_fields)
      stocks = []
      symbols = _get_symbols_for_name(name, exchanges)
      if options.has_key?(:limit) && options[:limit].to_i > 0
        symbols = symbols.take(options[:limit].to_i)
      end
      symbols.each do |symbol|
        stock = StockQuote::Stock.quote(symbol, nil, nil, data_fields)
        stocks << stock unless stock.failure?
      end
      return stocks
    end


    def self.get_stocks(names, options=OPTIONS, exchanges=EXCHANGES, data_fields=DATA_FIELDS)
      if options.empty? then options = OPTIONS end
      names = Array(names)
      stocks = []
      names.each do |name|
        stocks.concat(_handle_name(name, options, exchanges, data_fields))
      end
      return stocks
    end
  end
end