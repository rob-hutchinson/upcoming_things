require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "can favorite albums" do
    user1 = create :user
    album1 = create :album, artist: "Dan Deacon"

    album1.favorite user1

    expect(user1.favorites.count).to eq 1
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Dan Deacon"
  end

  it "can have multiple users favorite the same album" do
    user1 = create :user
    user2 = create :user
    album1 = create :album, artist: "The Decemberists"

    album1.favorite user1
    album1.favorite user2

    expect(Favorite.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "The Decemberists"
    expect(Album.find(user2.favorites.first.album_id).artist).to eq "The Decemberists"
  end

  it "can have multiple favorites" do
    user1 = create :user
    album1 = create :album, artist: "Courtney Barnett"
    album2 = create :album, artist: "Fleet Foxes"

    album1.favorite user1
    album2.favorite user1

    expect(user1.favorites.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Courtney Barnett"
    expect(Album.find(user1.favorites.last.album_id).artist).to eq "Fleet Foxes"
  end

  it "can't favorite the same album twice" do
    user1 = create :user
    album1 = create :album

    album1.favorite user1
    album1.favorite user1

    expect(Favorite.count).to eq 1
    expect(user1.favorites.count).to eq 1
    expect(album1.favorites.count).to eq 1
  end

  it "can unfavorite an album" do
    user1 = create :user
    album1 = create :album
    album2 = create :album

    album1.favorite user1
    album2.favorite user1
    album1.unfavorite user1

    expect(Favorite.count).to eq 1
    expect(user1.favorites.count).to eq 1
    expect(album1.favorites.count).to eq 0
    expect(album2.favorites.count).to eq 1
  end

  it "can check the distance between two users" do
    2.times do |x|
      create :user
    end

    5.times do |x|
      create :album
    end

    Album.find_each do |x|
      x.favorite User.first
    end

    Album.first.favorite User.last
    Album.last.favorite User.last

    expect(User.new.check_distance User.first, User.last).to eq 0.4
  end

  it "can find the closest match between users" do
    3.times do |x|
      create :user
    end

    5.times do |x|
      create :album
    end

    Album.first.favorite User.first
    Album.find(3).favorite User.first
    Album.find(5).favorite User.first

    Album.first.favorite User.find(2)

    Album.find(2).favorite User.last

    expect(User.first.find_match).to eq User.find(2)
    expect(User.find(2).find_match).to eq User.first
    expect(User.last.find_match).to eq nil
  end

  it "can recommend albums with 2 users" do
    2.times do |x|
      create :user 
    end
    n = 1
    5.times do |x|
      create :album, artist: "Artist #{n}"
      n += 1 
    end
    
    Album.first.favorite User.first
    Album.find(3).favorite User.first

    Album.first.favorite User.last

    expect(User.first.recommendations).to eq nil
    expect(Album.find(User.last.recommendations).artist).to eq "Artist 3" 
  end 
end
