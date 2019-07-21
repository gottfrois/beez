require "singleton"
require "optparse"
require "beez"
require "beez/launcher"

module Beez
  class CLI
    include Singleton

    attr_accessor :launcher

    def parse(args = ARGV)
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
        ::Beez.logger.warn "Signal #{sig} not supported"
      end

      launch(self_read)
    end

    private

    def boot
    end

    def launch(self_read)
      @launcher = ::Beez::Launcher.new

      ::Beez.logger.info "Starting processing, hit Ctrl-C to stop"

      begin
        launcher.run

        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          handle_signal(signal)
        end
      rescue Interrupt
        ::Beez.logger.info "Shutting down"
        launcher.stop
        ::Beez.logger.info "Bye!"
        exit(0)
      end
    end

    def handle_signal(signal)
      handler = signal_handlers[signal]
      if handler
        handler.call(self)
      else
        ::Beez.logger.warn "No signal handler for #{signal}"
      end
    end

    def signal_handlers
      {
        "INT" => ->(cli) { raise Interrupt },
        "TERM" => ->(cli) { raise Interrupt },
      }
    end
  end
end
