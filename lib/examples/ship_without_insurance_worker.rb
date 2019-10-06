require "beez"

module Beez
  class ShipWithoutInsuranceWorker
    include ::Beez::Worker

    type "ship-without-insurance"
    max_jobs_to_activate 5
    poll_interval 1

    def process(job)
      rand(35).times do |i|
        logger.info "Processing job #{job.type} #{job.key} by waiting #{i}s"
        sleep 1
      end
    end
  end
end
