# frozen_string_literal: true

module Chequeo
  class Manager

    attr_reader :workers

    def initialize
      Chequeo.config.logger.debug "Creating Worker Pool"
      @workers ||= []

      Chequeo.config.workers.times do
        @workers << Chequeo::CheckupProcessor.new
      end
      Chequeo.config.logger.debug "Creating Worker Pool"
    end

    def process
      Chequeo.config.logger.debug "Starting Worker Pool"
      @workers.each do |w|
        w.process
      end
      Chequeo.config.logger.debug "Starting Worker Pool"
    end

  end
end