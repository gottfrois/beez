module Beez
  class Rails < ::Rails::Engine
    class Reloader
      def initialize(app = ::Rails.application)
        @app = app
      end

      def call
        @app.reloader.wrap do
          yield
        end
      end

      def inspect
        "#<Beez::Rails::Reloader @app=#{@app.class.name}>"
      end
    end

    # This hook happens after all initializers are run, just before returning
    # from config/environment.rb back to beez/cli.rb.
    #
    # None of this matters on the client-side, only within the Beez process itself.
    config.after_initialize do
      Beez.configure_server do |_|
        Beez.options[:reloader] = Beez::Rails::Reloader.new
      end
    end
  end
end
