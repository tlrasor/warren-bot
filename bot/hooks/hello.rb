module Warren
  module Hooks
    class Hello

      def initialize
        yield self if block_given?
      end

      def call(client, _data)
        return unless client && File.file?("config/quotes.yml")
        puts "Im alive!"
      end

    end
  end
end