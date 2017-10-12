module SlackWarrenbot
  module SecHelper


    def get_sec_entity(symbol)
      begin
        return SecQuery::Entity.find({:symbol=> symbol})
      rescue
        return SecQuery::Entity.new({})
      end
    end
  end
end