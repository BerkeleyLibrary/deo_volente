# frozen_string_literal: true

# Dataload object represents a data load request from a user.
class Dataload < ApplicationRecord
  has_many :datafiles, dependent: :destroy

  scope :non_archived, -> { where.not(status: 4) }

  validates :doi, :mountPoint, :directory, :user_name, presence: true
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum :status, { created: 0, in_progress: 1, completed: 2, failed: 3 }, default: :created

  # TODO: check mount/directory for files
  def file?; end

  # TODO: initiate the "Dataload" job
  def submit; end

  def completed_at
    # Only show the "End Time" if the status is "completed" or "failed"
    return updated_at if status == 'completed' || status == 'failed'

    nil
  end

  def mount_point_directory
    "#{mountPoint}: #{directory}"
  end

  def archived?
    archived ? 'Yes' : 'No'
  end
end
