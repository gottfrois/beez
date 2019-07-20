require 'pry'

module Beez
  class JobPoller
    attr_reader :client, :worker, :remaining

    def initialize(client:, worker:)
      @client = client
      @worker = worker
      @remaining = 0
    end

    def poll
      puts "Polling #{max_jobs_to_activate} jobs to worker #{worker_name} every #{worker_poll_interval}s ; remaining is #{@remaining}..."
      activate_jobs
      sleep(worker_poll_interval)
    end

    private

    def activate_jobs
      activate_jobs_request.each do |response|
        @remaining += response.jobs.count
        response.jobs.each do |job|
          begin
            w = worker.new
            w.client = client
            w.process(job)
            w.complete_job(job)
          rescue => e
            w.fail_job(job, reason: e.message)
          end
        end
      end
    end

    def activate_jobs_request
      client.activate_jobs(::Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new(
        type: worker_type,
        worker: worker_name,
        timeout: worker_timeout,
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

    def worker_poll_interval
      worker.get_poll_interval
    end

    def worker_timeout
      worker.get_timeout
    end

    def worker_variables_to_fetch
      worker.get_variables_to_fetch
    end

    def max_jobs_to_activate
      worker_max_jobs_to_activate - remaining
    end
  end
end
