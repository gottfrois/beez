require "beez/poller"
require "beez/poller_observer"

module Beez
  class Launcher
    attr_reader :pollers

    def initialize
      @pollers = []
    end

    def run
      @pollers = workers.map do |worker|
        poller = ::Beez::Poller.new(client: client, worker: worker)
        task = ::Concurrent::TimerTask.new(run_now: true, execution_interval: worker.get_poll_interval, timeout_interval: worker.get_timeout) do
          poller.poll
        end
        task.add_observer(::Beez::PollerObserver.new)
        task.execute
        task
      end
    end

    def stop
      @pollers.each(&:shutdown)
    end

    private

    def workers
      ::Beez.workers.to_a
    end

    def client
      ::Beez.client
    end
  end
end
