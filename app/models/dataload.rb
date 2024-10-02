# frozen_string_literal: true

# Dataload object represents a data load request from a user.
class Dataload < ApplicationRecord
  has_many :datafiles, dependent: :destroy

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
  # returns a bare DOI (without protocol or proxy)
  def bare_doi
    doi[%r{10.\d{4,9}/[-._;()/:A-Z0-9]+$}]
  end

  def path_doi
    bare_doi.split('/')
  end

  # @todo should this be obfuscated somehow?
  def realpath
    path = DataverseService::Mountpoints.new.public_send("#{mountPoint}_path")
    Pathname.new(path).join(directory)
  end
end
