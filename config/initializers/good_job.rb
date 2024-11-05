# frozen_string_literal: true

Rails.application.configure do 
  config.good_job = {
    # Only test should run as :inline; prod/dev should be :external
    execution_mode: (Rails.env.test? ? :inline : :external),
    on_thread_error: ->(exception) { Rails.logger.error(exception) }, # default
    max_threads: ENV.fetch('GOOD_JOB_MAX_THREADS', 5),
  }
end