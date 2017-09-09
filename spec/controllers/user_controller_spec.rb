require 'spec_helper'

describe UsersController do

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to index' do
      params = {
        :name => "FantasyWinner",
        :email => "GoTeam@aol.com",
        :password => "SuperBowl"
      }
      post '/signup', params
      expect(last_response.location).to include("/index")
    end

      it 'does not let a user sign up without a username' do
        params = {
          :name => "",
          :email => "GoTeam@aol.com",
          :password => "SuperBowl"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'does not let a user sign up without an email' do
        params = {
          :name => "FantasyWinner",
          :email => "",
          :password => "SuperBowl"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'does not let a user sign up without a password' do
        params = {
          :name => "FantasyWinner",
          :email => "GoTeam@aol.com",
          :password => ""
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end


  end
end
