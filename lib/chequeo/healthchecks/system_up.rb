
# frozen_string_literal: true

module Chequeo
  module HealthChecks
    class SystemUp < Base

      def process
        Chequeo.config.dead_man_switch.call if Chequeo.config.dead_man_switch
      end

      def notify
        return #do not notify since we are going to hit the endpoint for checkins
      end

    end
  end
end