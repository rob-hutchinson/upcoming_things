FactoryGirl.define do
  factory :album do
    sequence(:artist) { |n| "Artist #{n}" }
    sequence(:album_title) { |n| "Album #{n}" }
    release_date "2015-03-31"
    thumbnail "MyString"
  end

end
