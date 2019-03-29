require 'dotenv'
Dotenv.load unless (ENV['RACK_ENV'] && ENV['RACK_ENV'] == 'production')

require 'stethoscope'
use Stethoscope

require_relative './warren-bot'
require_relative './warren-web'

# Thread.abort_on_exception = true

# Thread.new do
#   begin
#     Warren::Bot.run
#   rescue Exception => e
#     STDERR.puts "ERROR: #{e}"
#     STDERR.puts e.backtrace
#     raise e
#   end
# end

# run Warren::Web

begin
    Warren::Bot.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end
  