# frozen_string_literal: true

module StubHelper
  def create_dataload(num:, archived: false)
    Dataload.create!(
      doi: "Dataload #{num}",
      mountPoint: 'mntpt',
      directory: 'dir',
      user_name: 'user',
      user_email: "usr#{num}@email.com",
      archived:
    )
  end
end

RSpec.configure do |config|
  config.include(StubHelper)
end
