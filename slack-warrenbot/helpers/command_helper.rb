require 'color-generator'

module SlackWarrenbot
  module CommandHelper

    GENERATOR = ColorGenerator.new saturation: 0.75, lightness: 0.75

    def get_color(color=nil)
      if color == :blue
        return "8fbcef"
      end
      return GENERATOR.create_hex
    end

  end
end