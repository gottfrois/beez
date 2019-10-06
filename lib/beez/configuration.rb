module Beez
  class Configuration

    attr_accessor :logger, :zeebe_url, :timeout

    def initialize
      @logger = Logger.new($stdout)
      @zeebe_url = ENV['ZEEBE_URL'] || 'localhost:26500'
      @timeout = 30
    end
  end
end
