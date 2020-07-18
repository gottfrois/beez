require "beez"

module Workers
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

  class ShipWithInsuranceWorker
    include ::Beez::Worker

    type "ship-with-insurance"
    max_jobs_to_activate 5
    poll_interval 1

    def process(job)
      rand(35).times do |i|
        logger.info "Processing job #{job.type} #{job.key} by waiting #{i}s"
        sleep 1
      end
    end
  end

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
