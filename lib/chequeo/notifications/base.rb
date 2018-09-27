# frozen_string_literal: true

module Chequeo
  module Notifications
    class Base

      attr_accessor :rules, :configuration

      def initialize(options = {})
        @rules = {:on_completion => true, :warning_threshold  => 10, :error_threshold => 10}
        @configuration = {}
      end

      def configure(rules = {}, config = {})
        @rules.merge!(rules)
        @configuration.merge!(config)
      end

      def valid?
        true
      end

      def send_notifications( job , job_rules = {})
        return unless valid?
        _rules = @rules.merge(job_rules) #merge in job specific overrides
        send_warnings(job) if job.warnings.count > 0 && job.warnings.count >= ( _rules[:warning_threshold] || 0 )
        send_errors(job) if job.errors.count > 0 && job.errors.count >= ( _rules[:error_threshold] || 0 )
        send_on_completion(job) if _rules[:on_completion]
      end

      def send_warnings
        return
      end

      def send_errors
        return
      end

      def send_on_completion
        return
      end

    end
  end
end