module SlackWarrenbot
  module QueriesHelper

    def parse_query(query)
      terms = query.split(" ")
      options = _parse_query_options(terms)
      names = terms.select { |t| !t.include?('=') }

      puts "Received query #{query}, parsed names: #{names} and options: #{options}"
      return names, options
    end

    def _parse_query_options(terms)
      opts = {}
      options = terms.select { |t| t.include?('=') }
      options.each do |opt|
        key, value = opt.split(/=/)
        if value.include?(',') then value = value.split(/,/) end
        opts[key.to_sym] = value
      end
      return opts
    end

  end
end