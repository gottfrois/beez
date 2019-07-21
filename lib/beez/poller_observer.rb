module Beez
  class PollerObserver
    def update(time, res, exception)
      case exception
      when Concurrent::TimeoutError
        logger.warn "Poller timed out"
      else
        logger.error "Poller failed with error: #{exception.message}"
        logger.error exception.backtrace.join("\n")
      end
    end

    private

    def logger
      ::Beez.logger
    end
  end
end
