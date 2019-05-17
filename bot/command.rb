module Warren
  class Command < SlackRubyBot::Commands::Base

    def command *cmds
      super.command *cmds do |client, data, _match|
        begin
          yield(client, data, _match)
        rescue => e
          client.say(channel: data.channel, text: "I couldn't process this request due to an error. Please check your query.")
          puts e
        end
      end
    end


  end
end