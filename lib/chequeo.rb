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