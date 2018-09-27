# frozen_string_literal: true

require 'chequeo/notifications/base'

module Chequeo
  module Notifications
    class Logger < Base

      #
      # configuration: {
      #   logger: LOGGER_INSTANCE
      # }

      def valid?
        @configuration && @configuration.has_key?(:logger)
      end

      def send_on_completion(job)
        _text = job.get_text
        send_logger(_text)
      end

      def send_warnings(job)
        job.warnings.each{|x| send_logger_warning("#{job.get_short_job_title}#{x}") }
      end

      def send_errors(job)
        job.errors.each{|x| send_logger_error("#{job.get_short_job_title}#{x}") }
      end

      def send_logger_warning(text)
        begin
          @configuration[:logger]
        rescue => e
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.backtrace.inspect}"
        end
      end

      def send_logger_error(text)
        begin
          @configuration[:logger]
        rescue => e
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.backtrace.inspect}"
        end
      end

      def send_logger_notice(text)
        begin
          @configuration[:logger]
        rescue => e
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Notifications::Logger.send_notifications - #{e.backtrace.inspect}"
        end
      end

    end
  end
end