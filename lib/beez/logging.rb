module Beez
  module Logging
    def logger
      @logger || setup_logger
    end

    def logger=(logger)
      @logger = logger
    end

    def setup_logger
      @logger = Beez.config.logger
    end
  end
end
