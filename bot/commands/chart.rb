module Warren
  module Commands
    class Watch < Warren::Command

      extend Warren::Helpers::Queries

      command 'chart' do |client, data, _match|
        query = _match['expression']
          puts "_match['expression']=#{query}"
          puts "data=#{data}"
          puts "match=#{_match}"
          client.say(channel: data.channel, text: ":mag_right: Looking up a chart for _#{query}_...")
          client.typing channel: data.channel

          names, options = parse_query(query)

          names.each { |name|
            pnglink = "https://warren-charts.herokuapp.com/#{name}.png"
            client.say(channel: data.channel, text: pnglink)
          }
      end
    end
  end
end


