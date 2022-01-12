require 'beez'

module Workers
  class InitiatePaymentWorker
    include ::Beez::Worker

    type 'initiate-payment'
    max_jobs_to_activate 20
    poll_interval 1
    timeout 30

    def process(_job)
      rand(5).times do |_i|
        sleep 1
      end
    end
  end

  class ShipWithInsuranceWorker
    include ::Beez::Worker

    type 'ship-with-insurance'
    max_jobs_to_activate 5
    poll_interval 1

    def process(_job)
      rand(5).times do |_i|
        sleep 1
      end
    end
  end

  class ShipWithoutInsuranceWorker
    include ::Beez::Worker

    type 'ship-without-insurance'
    max_jobs_to_activate 5
    poll_interval 1

    def process(job)
      raise ArgumentError, "orderValue can't be < 10" if JSON.parse(job.variables)['orderValue'].to_i < 10

      rand(5).times do |_i|
        sleep 1
      end
    end
  end
end
