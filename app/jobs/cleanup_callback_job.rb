# frozen_string_literal: true

# callback job to cleanup
class CleanupCallbackJob < ApplicationJob
  queue_as :default

  def perform(batch, context)
    # @todo this might not be the right logic; my guess is this is where
    # we would drop notifications, etc.
    if context[:event] == 'success'
      batch.properties[:dataload].update!(status: :completed)
    else
      batch.properties[:dataload].update!(status: :failed)
    end
  end
end
