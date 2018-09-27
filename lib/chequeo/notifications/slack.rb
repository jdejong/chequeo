# frozen_string_literal: true

require 'chequeo/notifications/base'
require 'slack-ruby-client'

module Chequeo
  module Notifications
    class Slack < Base

      #
      # configuration: {
      #   token: YOUR_SLACK_API_TOKEN,
      #   channel: YOUR_SLACK_CHANNEL_HERE
      # }

      def valid?
        @configuration && @configuration.has_key?(:token) && @configuration.has_key?(:channel)
      end

      def send_on_completion(job)
        _title = job.get_job_title
        _text = job.get_text
        send_message(_text, "good", _title)
      end

      def send_warnings(job)
        _title = job.get_job_title
        _warnings = job.warnings.collect{|x| "- #{x}"}.join("\n")
        send_message(_warnings, "warning", _title)
      end

      def send_errors(job)
        _title = job.get_job_title
        _errors = job.errors.collect{|x| "- #{x}"}.join("\n")
        send_message(_errors, "danger", _title)
      end

      def send_message(text, color, title)
        begin
          client = ::Slack::Web::Client.new(token: @configuration[:token])
          client.chat_postMessage(
              channel: "#{@configuration[:channel]}",
              as_user: true,
              attachments: [
                  {
                      fallback: "Chequeo has posted a notification to slack.",
                      title: title,
                      text: text,
                      color: color
                  }
              ]
          )
        rescue => e
          Chequeo.config.logger.error "Chequeo::Notifications::Slack.send_notifications - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Notifications::Slack.send_notifications - #{e.backtrace.inspect}"
        end
      end

    end
  end
end