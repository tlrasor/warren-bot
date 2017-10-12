require 'stock_quote'

module SlackWarrenbot
  module StocksHelper

    EXCHANGES = ['NYQ', 'NAS']
    DATA_FIELDS = ['Symbol', 'Name', 'Ask', 'ChangeinPercent','LastTradeDate','LastTradeTime', 'LastTradePriceOnly', 'Change','Open','High','Low']
    OPTIONS = { :limit => 3 }

    def get_stocks(names, options=OPTIONS, exchanges=EXCHANGES, data_fields=DATA_FIELDS)
      if options.empty? then options = OPTIONS end
      names = Array(names)
      stocks = []
      names.each do |name|
        stocks.concat(_handle_name(name, options, exchanges, data_fields))
      end
      return stocks
    end

    def get_symbols(names, options=OPTIONS, exchanges=EXCHANGES)
      symbols = []
      names = Array(names)
      names.each do |name|
        symbols.concat(StockQuote::Symbol.lookup(name, exchanges))
      end
      return symbols
    end

    def _get_symbols_for_name(name, exchanges)
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

    def _handle_name(name, options, exchanges, data_fields)
      stocks = []
      symbols = _get_symbols_for_name(name, exchanges)
      if options.has_key?(:limit) && options[:limit].to_i > 0
        symbols = symbols.take(options[:limit].to_i)
      end
      symbols.each do |symbol|
        stock = StockQuote::Stock.quote(symbol)
        stocks << stock unless stock.failure?
      end
      return stocks
    end
    
  end
end