# frozen_string_literal: true

module Chequeo
  class Configuration

    attr_accessor :test, :notifications


    def initialize
      @test = nil
      @notifications = []
    end

  end
end