# frozen_string_literal: true

# Datafile object
class Datafile < ApplicationRecord
  include ActiveModel::Serialization

  belongs_to :dataload

  validates :origFilename, presence: true

  enum :status, { created: 0, in_progress: 1, completed: 2, failed: 3, archived: 4 }, default: :created

  def pathname
    @pathname ||= Pathname.new(origFilename)
  end

  def as_dataverse_json(options = {
    except: %i[id origFilename realpath dataverseId status created_at updated_at dataload_id]
  })
    json = as_json(options)
    json['storageIdentifier'] = DataverseService::StorageIdentifier.to_uri(id: json['storageIdentifier'])
    json['fileName'] = json['filename']
    json.delete('filename')
    json
  end
end
