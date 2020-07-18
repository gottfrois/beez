require 'singleton'
require 'optparse'
require 'fileutils'
require 'beez'
require 'beez/launcher'

$stdout.sync = true

module Beez
  class CLI
    include Singleton

    attr_accessor :launcher

    def parse(argv = ARGV)
      parse_options(argv)
      validate!
    end

    def run
      boot

      self_read, self_write = IO.pipe
      sigs = %w[INT TERM]
      sigs.each do |sig|
        trap sig do
          self_write.write("#{sig}\n")
        end
      rescue ArgumentError
        logger.warn "Signal #{sig} not supported"
      end

      launch(self_read)
    end

    private

    def parse_options(argv)
      option_parser.parse!(argv)
    end

    def option_parser
      OptionParser.new.tap do |p|
        p.on "-e", "--env ENV", "Application environment" do |arg|
          config.env = arg
        end

        p.on "-r", "--require [PATH|DIR]", "Location of Rails application with workers or file to require" do |arg|
          raise ArgumentError, "#{arg} doesn't exist" if !File.exist?(arg) && !File.directory?(arg)
          config.require = arg
        end

        p.on "-t", "--timeout NUM", "Shutdown timeout" do |arg|
          timeout = Integer(arg)
          raise ArgumentError, "timeout must be a positive integer" if timeout <= 0
          config.timeout = timeout
        end

        p.on "-v", "--verbose", "Print more verbose output" do |arg|
          ::Beez.logger.level = ::Logger::DEBUG
        end

        p.on "-V", "--version", "Print version and exit" do |arg|
          puts "Beez #{::Beez::VERSION}"
          exit(0)
        end

        p.banner = "Usage: beez [options]"
        p.on_tail "-h", "--help", "Show help" do
          puts p

          exit(1)
        end
      end
    end

    def validate!
      if !File.exist?(config.require) ||
          (File.directory?(config.require) && !File.exist?("#{config.require}/config/application.rb"))
        logger.info "==========================================================="
        logger.info "  Please point Beez to a Rails application or a Ruby file  "
        logger.info "  to load your worker classes with -r [DIR|FILE]."
        logger.info "==========================================================="

        exit(1)
      end
    end

    def boot
      ENV["RACK_ENV"] = ENV["RAILS_ENV"] = config.env

      if File.directory?(config.require)
        require 'rails'
        if ::Rails::VERSION::MAJOR < 4
          raise "Beez does not supports this version of Rails"
        else
          require File.expand_path("#{config.require}/config/environment.rb")
          logger.info "Booted Rails #{::Rails.version} application in #{config.env} environment"
        end
      else
        require config.require
      end
    end

    def launch(self_read)
      @launcher = ::Beez::Launcher.new

      if config.env == "development" && $stdout.tty?
        logger.info "Starting processing, hit Ctrl-C to stop"
      end

      begin
        launcher.start

        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          handle_signal(signal)
        end
      rescue Interrupt
        logger.info "Shutting down"
        launcher.stop
        logger.info "Bye!"

        exit(0)
      end
    end

    def handle_signal(signal)
      handler = signal_handlers[signal]
      if handler
        handler.call(self)
      else
        logger.warn "No signal handler for #{signal}"
      end
    end

    def signal_handlers
      {
        "INT" => ->(cli) { raise Interrupt },
        "TERM" => ->(cli) { raise Interrupt },
      }
    end

    def config
      ::Beez.config
    end

    def logger
      ::Beez.logger
    end
  end
end
