# queries.rb

module Utilities
  class Queries

    def self._parse_options(terms)
      opts = {}
      options = terms.select { |t| t.include?('=') }
      options.each do |opt|
        key, value = opt.split(/=/)
        opts[key.to_sym] = value
      end
      return opts
    end


    def self.parse(query)
      terms = query.split(" ")
      options = _parse_options(terms)
      names = terms.select { |t| !t.include?('=') }

      puts "Received query #{query}, parsed names: #{names} and options: #{options}"
      return names, options
    end

  end
end