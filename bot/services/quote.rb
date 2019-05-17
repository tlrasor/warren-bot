module Warren
  module Services
    module Quote

      def self.random
        quotes = YAML.load(File.read("config/quotes.yml"))
        quote = quotes.sample
        ">\"#{quote["quote"]}\" - #{quote["attribution"]}"
      end

    end
  end
end