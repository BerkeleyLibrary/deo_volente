FactoryBot.define do
  factory :datafile do
    origFilename { 'foo.csv' }

    factory :datafile_with_dataload do
      dataload
    end
  end
end
