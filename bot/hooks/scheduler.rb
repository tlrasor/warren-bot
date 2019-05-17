module Warren
  module Hooks
    class Scheduler

      def initialize
        yield self if block_given?
      end

      def call(client, _data)
        return unless client
        Services::Scheduler.cron '30 8 * * 1-5' do
          client.say(channel: Config::Slack.home_channel, text: "The market is now open, people!")
        end

        Services::Scheduler.cron '0 11 * * 1-5' do
          client.say(channel: Config::Slack.home_channel, text: "It's mid day and your report should be here")
        end

        Services::Scheduler.cron '0 15 * * 1-5' do
          client.say(channel: Config::Slack.home_channel, text: "Ding ding! Thats it for today folks!")
        end

        Services::Scheduler.cron '0 9 * * *' do
          qt = Services::Quote.random
          client.say(channel: Config::Slack.home_channel, 
                     text: qt)
      end
      end
    end
  end
end