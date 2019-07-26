module Beez
  class Poller
    attr_reader :client, :worker, :remaining

    def initialize(client:, worker:)
      @client = client
      @worker = worker
      @remaining = 0
    end

    def poll
      activate_jobs if activate_jobs?
    end

    private

    def activate_jobs?
      remaining <= worker_max_jobs_to_activate
    end

    def activate_jobs
      activate_jobs_request.each do |response|
        @remaining += response.jobs.count

        logger.info "Polled jobs #{response.jobs.map(&:key)} for worker #{worker_name}..."

        response.jobs.each do |job|
          ::Concurrent::Future.execute do
            w = worker.new(client)
            begin
              w.process(job)
              w.complete_job(job)
            rescue => e
              w.fail_job(job, reason: e.message)
            ensure
              @remaining -= 1
            end
          end

        end
      end
    end

    def activate_jobs_request
      client.activate_jobs(::Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new(
        type: worker_type,
        worker: worker_name,
        timeout: worker_timeout * 1000,
        maxJobsToActivate: max_jobs_to_activate,
        fetchVariable: worker_variables_to_fetch,
      ))
    end

    def worker_type
      worker.get_type
    end

    def worker_name
      worker.get_name
    end

    def worker_max_jobs_to_activate
      worker.get_max_jobs_to_activate
    end

    def worker_timeout
      worker.get_timeout
    end

    def worker_variables_to_fetch
      worker.get_variables_to_fetch
    end

    def max_jobs_to_activate
      worker_max_jobs_to_activate - @remaining
    end

    def logger
      ::Beez.logger
    end
  end
end
