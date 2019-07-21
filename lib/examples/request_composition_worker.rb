require "beez"

module Beez
  class RequestCompositionWorker
    include ::Beez::Worker

    type "request-composition"
    max_jobs_to_activate 5
    poll_interval 1

    def process(job)
      r = rand(30)
      logger.info "Processing job #{job.type} #{job.key} by waiting #{r}s"
      sleep r
    end
  end
end
