class Dataload < ApplicationRecord
  validates :doi, :mountPoint, :directory, :user_name, presence: true
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum status: { created: 0, in_progress: 1, completed: 2, failed: 3, archived: 4 }

  # TODO: check mount/directory for files
  def hasFile?
  end

  # TODO: initiate the "Dataload" job
  def submit
  end
end


