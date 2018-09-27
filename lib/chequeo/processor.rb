# frozen_string_literal: true

module Chequeo
  class Processor

    attr_reader :thread

    def initialize #(mgr)
      Chequeo.config.logger.debug "Start Chequeo::Processor.initialize"
      #@mgr = mgr
      @thread = nil
      @completed = false
    end

    def process
      @thread ||= Thread.new {
        begin
          process_task
        rescue => e
          Chequeo.config.logger.error "Chequeo::Scheduler.process - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Scheduler.process - #{e.backtrace.inspect}"
        end
      }
    end

    def process_task
      return
    end

  end
end