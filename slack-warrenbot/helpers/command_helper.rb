require 'color-generator'

module SlackWarrenbot
  module CommandHelper

    GENERATOR = ColorGenerator.new saturation: 0.75, lightness: 0.75

    def get_color(color=nil)
      if color == :blue
        return "8fbcef"
      end
      if color == :green
        return '00FF00'
      end
      if color == :red
        return 'FF0000'
      end
      return GENERATOR.create_hex
    end
    
  end
end