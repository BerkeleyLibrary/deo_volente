# frozen_string_literal: true

# job to enumerate files within a directory for a dataload
class EnumerateFilesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # realpath = Pathname.new(path).realpath
    # Pathname.glob(realpath + '**/*') do |p|
    #   Datafile.new(whatever)
    # end
  end
end
