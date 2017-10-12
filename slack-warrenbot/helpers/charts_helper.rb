module SlackWarrenbot
  module ChartsHelper
    PERIOD = "6M"
    INTERVAL="86400"

    def get_chart_url(symbol, options = {})
      period = options.key?(:period) ? options[:period] : PERIOD
      interval = options.key?(:interval) ? options[:interval] : INTERVAL
      interval = _parse_interval(interval)
      return "https://finance.google.com/finance/getchart?q=#{symbol}&p=#{period}&i=#{interval}"
    end

    def _parse_interval(interval)
      if interval.scan(/\D/).empty?
        return interval
      end
      if interval.downcase.include?('m')
        interval = 60.to_s
      end
      if interval.downcase.include?('h')
        interval = (3600).to_s
      end
      if interval.downcase.include?('d')
        interval = (86400).to_s
      end
      if interval.downcase.include?('w')
        interval = ( 7 * 86400).to_s
      end
      if interval.downcase.include?('m')
        interval = (7 * 4 * 86400).to_s
      end
      return interval
    end
  end
end