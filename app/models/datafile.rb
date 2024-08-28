class Datafile < ApplicationRecord
  belongs_to :dataload

  validates :origFilename, presence: true

  enum :status, [:created, :in_progress, :completed, :failed, :archived], default: :created
end
