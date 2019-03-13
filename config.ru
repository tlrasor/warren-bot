require 'dotenv'
Dotenv.load

require 'stethoscope'
use Stethoscope

require_relative './warren-bot'
require_relative './warren-web'

Thread.abort_on_exception = true

Thread.new do
  begin
    Warren::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Warren::Web