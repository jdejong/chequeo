# frozen_string_literal: true

require 'galactic-senate'
require 'fugit'

module Chequeo
  class Scheduler < Chequeo::Processor
    def initialize(mgr)
      Chequeo.config.logger.debug "Start Chequeo::Scheduler.initialize"

      @leader = false

      GalacticSenate.configure do |config|
        config.redis = Chequeo.config.redis
        config.logger = Chequeo.config.logger

        config.on(:elected) do
          Rails.logger.warn "I was just elected!!"
          @leader = true
        end

        config.on(:ousted) do
          Rails.logger.warn "I was just ousted!!"
          @leader = false
        end
      end

      Chequeo.config.logger.debug "Starting the senate"

      GalacticSenate::Delegation.instance.debate

      Chequeo.config.logger.debug "Senate Started"

      Chequeo.config.redis.del("chequeo-jobs")

      Chequeo.config.schedules.each do |element|
        Chequeo.config.redis.sadd("chequeo-jobs", element.jid)
      end

      Chequeo.config.logger.debug "End Chequeo::Scheduler.initialize"
    end



    def process
      Chequeo.config.logger.debug "Start Chequeo::Scheduler.process"

      timer_task = Concurrent::TimerTask.new(execution_interval: 30) do |task|

        begin
          process_task
        rescue => e
          Chequeo.config.logger.error "Chequeo::Scheduler.process - #{e.message}"
          Chequeo.config.logger.error "Chequeo::Scheduler.process - #{e.backtrace.inspect}"
        end
      end

      timer_task.execute
      Chequeo.config.logger.debug "End Chequeo::Scheduler.process"
    end

    def process_task
      Chequeo.config.logger.debug "@leader = #{@leader}"
      return unless @leader

      Chequeo.config.schedules.each do |element|
        _tempest_fugit = Fugit::Cron.parse(element.cron)

        _last_element = Chequeo.config.redis.zrange("chequeo-job-#{element.jid}", -1, -1, :with_scores => true)
        _last_element_score = !_last_element.empty? ? _last_element[0][1] : -1

        #puts "next = #{_tempest_fugit.next_time.to_i} - previous = #{_tempest_fugit.previous_time.to_i} -  last = #{_last_element_score}"
        if _last_element_score <= _tempest_fugit.previous_time.to_i

          _job = element.klass.new(element.options)

          Chequeo.config.logger.debug "Chequeo::Scheduler::process_task - Queueing #{_job.jid} of type #{_job.class.name}"

          Chequeo.config.redis.lpush("chequeo-job-queue", _job.serialize)
          Chequeo.config.redis.zadd("chequeo-job-#{element.jid}", _job.enqueue_time, _job.jid)
          Chequeo.config.redis.zremrangebyrank("chequeo-job-#{element.jid}", 0, -26)
        end
      end

    end


  end
end





