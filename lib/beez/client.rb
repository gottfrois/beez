require 'zeebe/client'

module Beez
  class Client

    attr_reader :client

    def initialize(url: ::Beez.config.zeebe_url, opts: :this_channel_is_insecure)
      @client = ::Zeebe::Client::GatewayProtocol::Gateway::Stub.new(url, opts)
    end

    def activate_jobs(params = {})
      run(:activate_jobs,
        ::Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new(params)
      )
    end

    def complete_job(params = {})
      run(:complete_job,
        ::Zeebe::Client::GatewayProtocol::CompleteJobRequest.new(params)
      )
    end

    def fail_job(params = {})
      run(:fail_job,
        ::Zeebe::Client::GatewayProtocol::FailJobRequest.new(params)
      )
    end

    private

    def run(method, params = {})
      client.public_send(method, params)
    rescue ::GRPC::Unavailable => exception
      logger.error exception.message
      raise exception
    end

    def logger
      ::Beez.logger
    end
  end
end
