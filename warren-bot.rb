require 'dotenv'
Dotenv.load unless (ENV['RACK_ENV'] && ENV['RACK_ENV'] == 'production')

require_relative './bot/bot'

begin
    Warren::Bot.run
rescue Exception => e
  STDERR.puts "warren-bot: ERROR! #{e}"
  STDERR.puts e.backtrace
end
  