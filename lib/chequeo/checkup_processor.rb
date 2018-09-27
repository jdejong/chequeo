# frozen_string_literal: true

module Chequeo
  class CheckupProcessor < Chequeo::Processor

    def process_task
      while !@completed

        _job_to_process = Chequeo.config.redis.lpop("chequeo-job-queue")
        process_one _job_to_process if _job_to_process

        sleep 0.1 if !_job_to_process
      end
    end

    def process_one( job )
      _job = Chequeo::HealthChecks::Base.deserialize(job)

      _job.process
      _job.notify
    end

  end
end