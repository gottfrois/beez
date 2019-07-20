require "beez/job_poller"

module Beez
  class Server
    attr_reader :options, :quit

    def initialize(options)
      @options = options
    end

    def run!
      trap_signals

      while !quit do
        start_work_loop
      end
    end

    private

    def start_work_loop
      workers.each do |worker|
        poller = ::Beez::JobPoller.new(
          client: client,
          worker: worker,
        )
        poller.poll
      end
    end

    def workers
      ::Beez.workers.to_a
    end

    def client
      ::Beez.client
    end

    def trap_signals
      %w(QUIT TERM INT).each do |sig|
        trap(sig) do
          puts "Shutting down gracefully..."
          @quit = true
        end
      end
    end
  end
end
