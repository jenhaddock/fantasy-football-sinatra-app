require 'spec_helper'

describe UsersController do

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to index' do
      params = {
        :username => "FantasyWinner",
        :email => "GoTeam@aol.com",
        :password => "SuperBowl"
      }
      post '/signup', params
      expect(last_response.location).to include("/index")
    end



  end
end
