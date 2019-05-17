require 'singleton'
require 'rufus-scheduler'

module Warren
  module Services
    class Scheduler

      def self.method_missing(method, *args, &block)
        Scheduler.instance.send(method, *args, &block)
      end

      include Singleton

      def initialize
        @scheduler = Rufus::Scheduler.new
      end

      def method_missing(method, *args, &block)
        if @scheduler.respond_to?(method)
          @scheduler.send(method, *args, &block)
        else
          super
        end
      end

    end
  end
end