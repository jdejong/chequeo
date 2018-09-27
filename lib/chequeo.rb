# frozen_string_literal: true

module Chequeo

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Chequeo::Configuration.new
  end

  def self.reset
    @config = Chequeo::Configuration.new
  end

  def self.configure
    yield(config)
  end
end

require 'chequeo/configuration'

require 'chequeo/processor'
require 'chequeo/scheduler'
require 'chequeo/checkup_processor'
require 'chequeo/scheduled_job'
require 'chequeo/manager'

require 'chequeo/healthchecks/base'
require 'chequeo/healthchecks/test_check'
require 'chequeo/healthchecks/system_up'

require 'chequeo/notifications/base'
require 'chequeo/notifications/slack'
require 'chequeo/notifications/twilio'
require 'chequeo/notifications/webhook'