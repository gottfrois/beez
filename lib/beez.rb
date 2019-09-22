require "concurrent"

require "beez/configurable"
require "beez/logging"
require "beez/client"
require "beez/worker"
require "beez/version"

module Beez
  extend ::Beez::Configurable
  extend ::Beez::Logging

  # class Error < StandardError; end

  def self.register_worker(worker)
    self.workers << worker
  end

  def self.workers
    @workers ||= []
  end

  def self.client
    @client ||= ::Beez::Client.new
  end
end

require "examples/initiate_payment_worker"
require "examples/ship_with_insurance_worker"
require "examples/ship_without_insurance_worker"
