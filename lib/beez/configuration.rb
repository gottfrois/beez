module Beez
  class Configuration
    attr_accessor :env, :logger, :require, :timeout, :zeebe_url

    def initialize
      @env = ENV['APP_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      @logger = Logger.new($stdout)
      @require = '.'
      @timeout = 30
      @zeebe_url = ENV['ZEEBE_URL'] || 'localhost:26500'
    end
  end
end
