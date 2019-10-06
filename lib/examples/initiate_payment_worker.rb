require "beez"

module Beez
  class InitiatePaymentWorker
    include ::Beez::Worker

    type "initiate-payment"
    max_jobs_to_activate 5
    poll_interval 1
    timeout 30

    def process(job)
      rand(35).times do |i|
        logger.info "Processing job #{job.type} #{job.key} by waiting #{i}s"
        sleep 1
      end
    end
  end
end
