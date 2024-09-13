# frozen_string_literal: true

Rails.application.configure do 
  config.good_job = {
    # Only test should run as :async; prod/dev should be :external
    execution_mode: (Rails.env.test? ? :async : :external),
    on_thread_error: ->(exception) { Rails.logger.error(exception) }, # default
    max_threads: ENV.fetch('GOOD_JOB_MAX_THREADS', 5),
  }
end