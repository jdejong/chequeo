# frozen_string_literal: true

module Chequeo
  class ScheduledJob

    attr_accessor :cron, :klass, :options, :jid

    def initialize(cron, klass, options = {})
      @options = options
      @cron = cron
      @klass = klass
      @jid = Digest::SHA1.hexdigest("#{cron.to_s}:#{klass.to_s}:#{options.to_s}")
    end

    def get_klass
      klass  #TODO: Handle if klass is a string
    end

    def generate_job_run_id job_time
      { job_time: _time, job_id: Digest::SHA1.hexdigest("#{cron.to_s}:#{klass.to_s}:#{options.to_s}:#{job_time}") }
    end

  end
end