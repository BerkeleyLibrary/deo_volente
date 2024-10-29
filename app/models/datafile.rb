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

  def copy_to_dataverse_directory(dest_fn:)
    dest_path = Pathname.new(dest_fn)
    FileUtils.mkdir_p(dest_path.dirname)
    FileUtils.cp(origFilename, dest_path)
    dest_md5 = Digest::MD5.file(dest_path).hexdigest
    if md5Hash == dest_md5
      update!(status: :completed)
    else
      update!(status: :failed)
      raise StandardError, "Destination #{dest_fn} (#{dest_md5} does not match source #{origFilename} #{md5Hash}"
    end
  end

  def create_dataverse_object(doi:)
    client = DataverseService::ApiClient.new
    # @todo better error handling
    rsp = client.add_file(doi, metadata: as_dataverse_json)
    response_df = rsp.dig(:body, :data, :files)
    if rsp.dig(:body, :status) == 'OK'
      dataverseId = response_df.first.dig(:dataFile, :id)
      update!(dataverseId:, status: :completed)
    else
      update!(status: :failed)
      raise StandardError, "Datafile #{filename} did not upload successfully; response: #{rsp[:body].as_json}"
    end
  end
end
