require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage when not logged in' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Flatiron Fantasy Football!")
    end
    it 'loads the index when logged in' do
      user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
      params = {:name => "FantasyWinner",:password => "SuperBowl"}
      post '/login', params
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Fantasy Teams")
    end
  end
end
