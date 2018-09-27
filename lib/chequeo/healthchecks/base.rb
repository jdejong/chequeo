# frozen_string_literal: true

require 'oj'

module Chequeo
  module HealthChecks
    class Base

      attr_accessor :jid, :enqueue_time, :type, :errors, :warnings, :completion_text, :rules

      def initialize(options = {})
        @enqueue_time = Time.now.to_i
        @jid = Digest::SHA1.hexdigest("#{self.class.name}:#{options.to_s}:#{@enqueue_time}")
        @type = self.class.name
        @errors = []
        @warnings = []
        @completion_text = nil
        @rules = options.has_key?(:rules) ? options[:rules] : {}
      end

      def process
        return
      end

      def notify
        Chequeo.config.notifications.each do |notification|
          notification.send_notifications(self)
        end
      end

      def get_job_title
        "Chequeo Job ##{@jid} - #{self.class.name.demodulize}"
      end

      def get_short_job_title
        "[Chequeo] [#{self.class.name.demodulize}] ##{@jid} - "
      end

      def get_text
        val = "Chequeo Job ##{@jid} for type #{self.class.name.demodulize} completed"
        val += "\n\n#{@completion_text}" if @completion_text
        val
      end

      def serialize
        Oj.dump(self)
      end

      def self.deserialize(data)
        parsed_obj = Oj.load(data)
        parsed_obj
      end

    end
  end
end