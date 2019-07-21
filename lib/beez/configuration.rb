module Beez
  class Configuration

    attr_accessor :logger

    def initialize
      @logger = Logger.new($stdout)
    end
  end
end
