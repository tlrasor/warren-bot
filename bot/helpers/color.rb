require 'color-generator'

module Warren
  module Helpers
    module Color

      def hex_color(color=nil)
        case color
        when :blue
          "8fbcef"
        when :green
          '00FF00'
        when :red
          'FF0000'
        else
          generator.create_hex
        end
      end

      private

      def generator 
        @@generator ||= ColorGenerator.new saturation: 0.75, lightness: 0.75
      end
      
    end
  end
end