require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "can favorite albums" do
    user1 = create :user
    album1 = create :album, artist: "Dan Deacon"

    user1.favorite album1

    expect(user1.favorites.count).to eq 1
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Dan Deacon"
  end

  it "can have multiple users favorite the same album" do
    user1 = create :user
    user2 = create :user
    album1 = create :album, artist: "The Decemberists"

    user1.favorite album1
    user2.favorite album1

    expect(Favorite.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "The Decemberists"
    expect(Album.find(user2.favorites.first.album_id).artist).to eq "The Decemberists"
  end

  it "can have multiple favorites" do
    user1 = create :user
    album1 = create :album, artist: "Courtney Barnett"
    album2 = create :album, artist: "Fleet Foxes"

    user1.favorite album1
    user1.favorite album2

    expect(user1.favorites.count).to eq 2
    expect(Album.find(user1.favorites.first.album_id).artist).to eq "Courtney Barnett"
    expect(Album.find(user1.favorites.last.album_id).artist).to eq "Fleet Foxes"
  end

  it "can't favorite the same album twice" do
    user1 = create :user
    album1 = create :album

    user1.favorite album1
    user1.favorite album1

    expect(Favorite.count).to eq 1
    expect(user1.favorites.count).to eq 1
    expect(album1.favorites.count).to eq 1
  end

  it "can unfavorite an album" do
    user1 = create :user
    album1 = create :album
    album2 = create :album

    user1.favorite album1
    user1.favorite album2
    user1.unfavorite album1

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
      User.first.favorite x
    end

    User.last.favorite Album.first
    User.last.favorite Album.last

    expect(User.first.check_distance User.last).to eq 0.4
  end

  it "can find the closest match between users" do
    3.times do |x|
      create :user
    end

    5.times do |x|
      create :album
    end

    User.first.favorite Album.first
    User.first.favorite Album.find(3)
    User.first.favorite Album.find(5)

    User.find(2).favorite Album.first

    expect(User.first.find_match).to eq User.find(2)
    expect(User.find(2).find_match).to eq User.first
    expect(User.last.find_match).to eq User.find(2)
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
    
    User.first.favorite Album.first
    User.first.favorite Album.find(3)

    User.last.favorite Album.first

    expect(User.first.recommendation).to eq nil
    expect(Album.find(User.last.recommendation).artist).to eq "Artist 3" 
  end

  it "can appropriately recommend albums when there are more than 2 users" do
    4.times do |x|
      create :user
    end

    10.times do |x|
      create :album
    end

    Album.find_each do |x|
      User.first.favorite x
    end

    Album.where("id > 1").find_each do |x|
      User.find(2).favorite x
    end

    User.find(3).favorite Album.find(1)
    User.find(3).favorite Album.find(2)

    User.find(4).favorite Album.find(1)
    User.find(4).favorite Album.find(2)
    User.find(4).favorite Album.find(3)

    expect(User.first.recommendation).to eq nil
    expect(User.find(2).recommendation).to eq 1
    expect(User.find(3).recommendation).to eq 3
  end

end
