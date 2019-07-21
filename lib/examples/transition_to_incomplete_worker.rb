require "beez"

module Beez
  class TransitionToIncompleteWorker
    include ::Beez::Worker

    type "transition-to-incomplete"
    max_jobs_to_activate 1
    poll_interval 1

    def process(job)
      r = rand(30)
      logger.info "Processing job #{job.type} #{job.key} by waiting #{r}s"
      sleep r
    end
  end
end
