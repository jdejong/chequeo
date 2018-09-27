# frozen_string_literal: true

module Chequeo
  module HealthChecks
    class TestCheck < Base


      def process
        Chequeo.config.logger.debug "This is a test, this is only a test."
        return
      end

    end
  end
end