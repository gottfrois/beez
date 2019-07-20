require 'beez'

module Beez
  class RequestCompositionWorker
    include ::Beez::Worker

    FooError = Class.new(StandardError)

    type "request-composition"

    def process(job)
      puts "[#{self.class.name}] Processing #{job.inspect}"
    end
  end
end
