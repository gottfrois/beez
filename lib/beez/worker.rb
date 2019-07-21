require "json"

module Beez
  module Worker
    attr_accessor :client, :logger, :type, :max_jobs_to_activate, :poll_interval, :timeout, :variables

    def self.included(base)
      base.extend(ClassMethods)
      Beez.register_worker(base)
    end

    def initialize(client, logger: ::Beez.logger)
      @client = client
      @logger = logger
    end

    def complete_job(job, variables: {})
      logger.info "Done processing job #{job.type} #{job.key}"
      client.complete_job(::Zeebe::Client::GatewayProtocol::CompleteJobRequest.new(
        jobKey: job.key,
        variables: Hash(variables).to_json,
      ))
    end

    def fail_job(job, reason: "")
      logger.error "Failed processing job #{job.type} #{job.key}: #{reason}"
      client.fail_job(::Zeebe::Client::GatewayProtocol::FailJobRequest.new(
        jobKey: job.key,
        retries: job.retries - 1,
        errorMessage: reason,
      ))
    rescue => e
      logger.error e.message
    end

    module ClassMethods
      def type(type)
        @type = type
      end

      def get_type
        @type
      end

      def max_jobs_to_activate(max_jobs_to_activate)
        @max_jobs_to_activate = max_jobs_to_activate
      end

      def get_max_jobs_to_activate
        @max_jobs_to_activate || 1
      end

      def poll_interval(poll_interval)
        @poll_interval = poll_interval
      end

      def get_poll_interval
        @poll_interval || 5
      end

      def timeout(timeout)
        @timeout = timeout
      end

      def get_timeout
        @timeout || 30
      end

      def variables(variables)
        @variables = variables
      end

      def get_variables_to_fetch
        @variables.to_a
      end

      def get_name
        name = self.name.gsub(/::/, ':')
        name.gsub!(/([^A-Z:])([A-Z])/) { "#{$1}_#{$2}" }
        name.downcase
      end
    end
  end
end
