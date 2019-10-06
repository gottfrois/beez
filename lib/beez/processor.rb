module Beez
  class Processor

    attr_reader :client, :worker_class, :busy_count, :timer

    def initialize(client: ::Beez.client, worker_class:)
      @client = client
      @worker_class = worker_class
      @busy_count = ::Concurrent::AtomicFixnum.new(0)
      @timer = ::Concurrent::TimerTask.new(
        run_now: true,
        execution_interval: worker_poll_interval,
        timeout_interval: worker_timeout
      ) { run }
    end

    def start
      timer.execute
      self
    end

    def stop
      timer.shutdown
      self
    end

    def should_activate_jobs?
      busy_count.value <= worker_max_jobs_to_activate
    end

    private

    def run
      fetch if should_activate_jobs?
    end

    def fetch
      activate_jobs_request.each do |response|
        busy_count.increment(response.jobs.count)
        response.jobs.each do |job|
          ::Concurrent::Future.execute do
            process(job)
          end
        end
      end
    end

    def process(job)
      worker = worker_class.new(client)
      begin
        worker.process(job)
        worker.complete_job(job)
      rescue => exception
        worker.fail_job(job, reason: exception.message)
        raise exception
      ensure
        busy_count.decrement
      end
    end

    def activate_jobs_request
      client.activate_jobs(
        type: worker_type,
        worker: worker_name,
        timeout: worker_timeout * 1000,
        maxJobsToActivate: max_jobs_to_activate,
        fetchVariable: worker_variables_to_fetch,
      )
    end

    def worker_type
      worker_class.get_type
    end

    def worker_name
      worker_class.get_name
    end

    def worker_max_jobs_to_activate
      worker_class.get_max_jobs_to_activate
    end

    def worker_timeout
      worker_class.get_timeout
    end

    def worker_variables_to_fetch
      worker_class.get_variables_to_fetch
    end

    def worker_poll_interval
      worker_class.get_poll_interval
    end

    def max_jobs_to_activate
      worker_max_jobs_to_activate - busy_count.value
    end

    def logger
      ::Beez.logger
    end
  end
end
