require 'beez'

module Beez
  class TransitionToIncompleteWorker
    include ::Beez::Worker

    FooError = Class.new(StandardError)

    type "transiton-to-incomplete"

    def process(job)
      puts "[#{self.class.name}] Processing #{job.inspect}"
    end
  end
end
