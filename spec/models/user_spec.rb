require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "can favorite albums" do
    user1 = FactoryGirl.create :user
    album1 = FactoryGirl.create :album, artist: "Dan Deacon"

    album1.favorite user1

    expect(user1.favorites.count).to eq 1
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Dan Deacon"
  end

  it "can have multiple users favorite the same album" do
    user1 = FactoryGirl.create :user
    user2 = FactoryGirl.create :user
    album1 = FactoryGirl.create :album, artist: "The Decemberists"

    album1.favorite user1
    album1.favorite user2

    expect(Favorite.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "The Decemberists"
    expect(Album.find(user2.favorites.first.album_id).artist).to eq "The Decemberists"
  end

  it "can have multiple favorites" do
    user1 = FactoryGirl.create :user
    album1 = FactoryGirl.create :album, artist: "Courtney Barnett"
    album2 = FactoryGirl.create :album, artist: "Fleet Foxes"

    album1.favorite user1
    album2.favorite user1

    expect(user1.favorites.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Courtney Barnett"
    expect(Album.find(user1.favorites.last.album_id).artist).to eq "Fleet Foxes"
  end

  it "can't favorite the same album twice" do
    user1 = FactoryGirl.create :user
    album1 = FactoryGirl.create :album

    album1.favorite user1
    album1.favorite user1

    expect(Favorite.count).to eq 1
    expect(user1.favorites.count).to eq 1
    expect(album1.favorites.count).to eq 1
  end

  it "can unfavorite an album" do
    user1 = FactoryGirl.create :user
    album1 = FactoryGirl.create :album
    album2 = FactoryGirl.create :album

    album1.favorite user1
    album2.favorite user1
    album1.unfavorite user1

    expect(Favorite.count).to eq 1
    expect(user1.favorites.count).to eq 1
    expect(album1.favorites.count).to eq 0
    expect(album2.favorites.count).to eq 1
  end
end
