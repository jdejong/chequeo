# frozen_string_literal: true

module Chequeo
  class Configuration

    attr_accessor :test, :notifications, :schedules, :logger, :redis, :workers, :dead_man_switch


    def initialize
      @test = nil
      @notifications = []
      @schedules = []
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @redis = nil
      @workers ||= 5

      @schedules << Chequeo::ScheduledJob.new("*/5 * * * *", Chequeo::HealthChecks::SystemUp, {})
    end


    def schedule(crontab, checkup_class, options = {})
      Chequeo.config.logger.debug "Chequeo::Configuration.schedule - Loading #{checkup_class} to run on schedule #{crontab} with options #{options}"
      @schedules << Chequeo::ScheduledJob.new(crontab, checkup_class, options)
    end

    def add_notification(notification_class, rules = {}, configuration = {}, options = {})
      Chequeo.config.logger.debug "Chequeo::Configuration.add_notification - Adding #{notification_class} adding rules #{rules} and configuration #{configuration} with options #{options}"
      notification = notification_class.new(options)
      notification.configure(rules, configuration)
      @notifications << notification
    end

    def dead_mans_switch(&block)
      @dead_man_switch = block
    end

  end
end
