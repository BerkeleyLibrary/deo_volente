# frozen_string_literal: true

# Datafile object
class Datafile < ApplicationRecord
  belongs_to :dataload

  validates :origFilename, presence: true

  enum :status, { created: 0, in_progress: 1, completed: 2, failed: 3, archived: 4 }, default: :created
end
