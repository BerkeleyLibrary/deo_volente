FactoryBot.define do
  factory :dataload do
    doi { '10.1000/quux/baz' }
    mountPoint { :digital_assets }
    directory { 'foobar/data' }
    user_name { 'meow meow' }
    user_email { 'purr@cat.edu' }
  end
end
