require 'zeebe/client'

module Beez
  class Client
    attr_reader :client

    def initialize(url: ::Beez.config.zeebe_url, opts: :this_channel_is_insecure)
      @client = ::Zeebe::Client::GatewayProtocol::Gateway::Stub.new(url, opts)
    end

    def activate_jobs(params = {})
      client.activate_jobs(
        ::Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new(params)
      )
    end

    def complete_job(params = {})
      client.complete_job(
        ::Zeebe::Client::GatewayProtocol::CompleteJobRequest.new(params)
      )
    end

    def fail_job(params = {})
      client.fail_job(
        ::Zeebe::Client::GatewayProtocol::FailJobRequest.new(params)
      )
    end
  end
end
