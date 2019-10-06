require 'beez/configuration'

module Beez
  module Configurable
    def config
      @config ||= ::Beez::Configuration.new
    end

    def configure
      yield config if block_given?
    end
  end
end
