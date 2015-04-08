require 'rails_helper'

RSpec.describe Album, type: :model do

  fit "can recommend albums at all" do
    2.times do |x|
      FactoryGirl.create :user 
    end
    
    5.times do |x|
      FactoryGirl.create :album 
    end
    
    Album.first.favorite User.first
    Album.find(3).favorite User.first
    Album.find(5).favorite User.first

    Album.first.favorite User.last

    expect(User.first.recommendations.count).to eq 0
    expect(User.last.recommendations.count).to eq 2
    expect(User.last.recommendations.first.artist).to eq "Artist 1" 

    binding.pry
  end  
end
