require 'dotenv'
Dotenv.load unless (ENV['RACK_ENV'] && ENV['RACK_ENV'] == 'production')

require_relative './bot/bot'

Warren::Bot.run