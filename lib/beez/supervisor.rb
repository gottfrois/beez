require 'beez/processor'

module Beez
  class Supervisor
    def initialize
      @processors = []
    end

    def start
      @processors = workers.map do |worker_class|
        processor = ::Beez::Processor.new(worker_class: worker_class)
        processor.start
      end
    end

    def quiet
      logger.info 'Terminating workers'
      @processors.each(&:stop)
    end

    def stop(timeout: ::Beez.config.timeout)
      quiet
      logger.info "Pausing #{timeout}s to allow workers to finish..."
      sleep timeout
    end

    private

    def workers
      ::Beez.workers.to_a
    end

    def logger
      ::Beez.logger
    end
  end
end
