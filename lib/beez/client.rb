require 'zeebe/client'

module Beez
  class Client
    attr_reader :client

    def initialize(url: ::Beez.config.zeebe_url, opts: :this_channel_is_insecure)
      @client = ::Zeebe::Client::GatewayProtocol::Gateway::Stub.new(url, opts)
    end

    def activate_jobs(params = {})
      run(
        :activate_jobs,
        ::Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new(params)
      )
    end

    def cancel_workflow_instance(params = {})
      run(
        :cancel_workflow_instance,
        ::Zeebe::Client::GatewayProtocol::CancelWorkflowInstanceRequest.new(params)
      )
    end

    def complete_job(params = {})
      run(
        :complete_job,
        ::Zeebe::Client::GatewayProtocol::CompleteJobRequest.new(params)
      )
    end

    def create_workflow_instance(params = {})
      run(
        :create_workflow_instance,
        ::Zeebe::Client::GatewayProtocol::CreateWorkflowInstanceRequest.new(params)
      )
    end

    def deploy_workflow(params = {})
      run(
        :deploy_workflow,
        ::Zeebe::Client::GatewayProtocol::DeployWorkflowRequest.new(params)
      )
    end

    def fail_job(params = {})
      run(
        :fail_job,
        ::Zeebe::Client::GatewayProtocol::FailJobRequest.new(params)
      )
    end

    def throw_error(params = {})
      run(
        :throw_error,
        ::Zeebe::Client::GatewayProtocol::ThrowErrorRequest.new(params)
      )
    end

    def publish_message(params = {})
      run(
        :publish_message,
        ::Zeebe::Client::GatewayProtocol::PublishMessageRequest.new(params)
      )
    end

    def resolve_incident(params = {})
      run(
        :resolve_incident,
        ::Zeebe::Client::GatewayProtocol::ResolveIncidentRequest.new(params)
      )
    end

    # rubocop:disable Naming/AccessorMethodName
    def set_variables(params = {})
      run(
        :set_variables,
        ::Zeebe::Client::GatewayProtocol::SetVariablesRequest.new(params)
      )
    end
    # rubocop:enable Naming/AccessorMethodName

    def topology(params = {})
      run(
        :topology,
        ::Zeebe::Client::GatewayProtocol::TopologyRequest.new(params)
      )
    end

    def update_job_retries(params = {})
      run(
        :update_job_retries,
        ::Zeebe::Client::GatewayProtocol::UpdateJobRetriesRequest.new(params)
      )
    end

    private

    def run(method, params = {})
      client.public_send(method, params)
    rescue ::GRPC::Unavailable => e
      logger.error e.message
      raise e
    end

    def logger
      ::Beez.logger
    end
  end
end
