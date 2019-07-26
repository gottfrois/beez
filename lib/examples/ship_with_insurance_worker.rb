require "beez"

module Beez
  class ShipWithInsuranceWorker
    include ::Beez::Worker

    type "ship-with-insurance"
    max_jobs_to_activate 5
    poll_interval 1

    def process(job)
      # r = rand(30)
      r = 15
      logger.info "Processing job #{job.type} #{job.key} by waiting #{r}s"
      sleep r
    end
  end
end
