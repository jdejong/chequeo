# frozen_string_literal: true

$stdout.sync = true

require 'singleton'
require 'optparse'

module Chequeo
  class CLI

    include Singleton

    DEFAULTS = {

    }

    SIGNAL_HANDLERS = {
        # Ctrl-C in terminal
        'INT' => ->(cli) { raise Interrupt },
        # TERM is the signal that the daemon must exit.
        'TERM' => ->(cli) { raise Interrupt },
        'USR1' => ->(cli) {
          Rails.logger.info "Received USR1, no longer accepting requests"
          cli.launcher.quiet
        },
        'TSTP' => ->(cli) {
          Rails.logger.info "Received TSTP, no longer accepting requests"
          cli.launcher.quiet
        },
        'USR2' => ->(cli) {

        },
        'TTIN' => ->(cli) {
          Thread.list.each do |thread|
            Rails.logger.warn "Thread TID-#{(thread.object_id ^ ::Process.pid).to_s(36)}"
            if thread.backtrace
              Rails.logger.warn thread.backtrace.join("\n")
            end
          end
        },
    }

    def self.options
      @options ||= DEFAULTS.dup
    end

    def self.options=(opts)
      @options = opts
    end

    def options
      Chequeo::CLI.options
    end

    def setup(args=ARGV)
      setup_options(args)
      require_system

      write_pid
    end

    def start
      Chequeo.config.logger.debug "Starting Daemon - #{ENV['RAILS_ENV']}"

      self_read, self_write = IO.pipe
      sigs = %w(INT TERM TTIN TSTP USR1 USR2)

      sigs.each do |sig|
        begin
          trap sig do
            self_write.write("#{sig}\n")
          end
        rescue ArgumentError
          puts "Signal #{sig} not supported"
        end
      end

      begin

        #spwan scheduler and worker pools

        Chequeo.config.logger.debug "Starting Schedule Process"
        Chequeo::Scheduler.new(nil).process
        Chequeo.config.logger.debug "Done Starting Schedule Process"

        Chequeo::Manager.new.process

        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          puts "*** SIGNAL RECEIVED :: #{signal} ***"
          handle_signal(signal)
        end
      rescue Interrupt
        Rails.logger.info 'Shutting down'

        exit(0)
      end

    end

    def handle_signal(sig)
      Rails.logger.debug "Got #{sig} signal"
      handy = SIGNAL_HANDLERS[sig]
      if handy
        handy.call(self)
      else
        Rails.logger.info { "No signal handler for #{sig}" }
      end
    end

    private

    def setup_options(args)
      opts = parse_options(args)

      options.merge!(opts)
    end

    def parse_options(argv)
      opts = {}

      argv.options do |args|
        args.on '-c', '--concurrency INT', "processor threads to use" do |arg|
          opts[:concurrency] = Integer(arg)
        end

        args.on '-d', '--daemon', "Daemonize process" do |arg|
          opts[:daemon] = arg
        end

        args.on "-v", "--verbose", "Print more verbose output" do |arg|
          opts[:verbose] = arg
        end

        args.on '-V', '--version', "Print version and exit" do |arg|
          puts "Chequeo #{Chequeo::VERSION}"
          exit(0)
        end

        args.parse!
      end

      opts
    end

    def require_system
      ENV['RACK_ENV'] = ENV['RAILS_ENV']

      require 'rails'

      require File.expand_path("./config/application.rb")
      require File.expand_path("./config/environment.rb")

    end

    def write_pid
      if path = options[:pidfile]
        pidfile = File.expand_path(path)
        File.open(pidfile, 'w') do |f|
          f.puts ::Process.pid
        end
      end
    end

  end
end
