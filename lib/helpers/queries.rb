module Warren
  module Helpers
    module Queries

      def parse_query(query)
        terms = query.split(" ")
        names = terms.select { |t| !t.include?('=') }
        options = {}
        terms.select { |t| t.include?('=') }.each do |opt|
          key, value = opt.split(/=/)
          value = value.split(",") if value.include?(',')
          options[key.to_sym] = value
        end
        puts "Received query #{query}, parsed names: #{names} and options: #{options}"
        return names, options
      end
    end
  end
end