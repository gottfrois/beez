require 'beez/supervisor'

module Beez
  class Launcher
    attr_reader :supervisor

    def initialize
      @supervisor = ::Beez::Supervisor.new
    end

    # Starts the supervisor and job processors.
    def start
      supervisor.start
    end

    # Tells the supervisor to stop processing any more jobs.
    def quiet
      supervisor.quiet
    end

    # Tells the supervisor to stop job processors. This method blocks until
    # all processors are complete and stopped. It can take up to configurable
    # timeout.
    def stop
      supervisor.stop
    end

    private

    def client
      ::Beez.client
    end
  end
end
