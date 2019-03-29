module Warren
  module Helpers
    module Yahoo

      def yahoo_profile symbol
        "https://finance.yahoo.com/quote/#{symbol}"
      end
    end
  end
end