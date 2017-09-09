require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:name => "Football Fan", :email => "FootballIsLife@aol.com", :password => "GoTeam")
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("football-fan")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).name).to eq("Football Fan")
  end

  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("GoTeam")).to eq(@user)

  end
end
