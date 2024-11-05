FactoryBot.define do
  factory :dataload do
    doi { '10.1000/quux/baz' }
    mountPoint { :digital_assets }
    directory { 'foobar' }
    user_name { 'meow meow' }
    user_email { 'purr@cat.edu' }
    # datafile

    factory :dataload_with_datafiles do
      transient do
        datafiles_count { 5 }
      end

      after(:create) do |dataload, evaluator|
        create_list(:datafile, evaluator.datafiles_count, dataload:)
        dataload.reload
      end
    end
  end
end
