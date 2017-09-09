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

      it 'does not let a logged in user view the signup page' do
        user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
        params = {
          :name => "FantasyWinner",
          :password => "SuperBowl"
        }
        post '/login', params
        expect(last_response.location).to include('/index')
      end

      it 'does not create duplicate user names' do
        user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
        params = {
          :name => "FantasyWinner",
          :email => "GoTeam@aol.com",
          :password => "SuperBowl"
        }
        post '/signup', params
        expect(last_response.location).to include('/login')
      end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the index after login' do
      user = User.create(:name => "I Love Football", :email => "GoTeam@aol.com", :password => "SuperBowl")
      params = {
        :name => "I Love Football",
        :password => "SuperBowl"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Fantasy Teams")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:name => "I Love Football", :email => "GoTeam@aol.com", :password => "SuperBowl")

      params = {
        :name => "I Love Football",
        :password => "SuperBowl"
      }
      post '/login', params
      expect(last_response.location).to include("/index")
    end

    it 'does not let user sign in with invalid password' do
      user = User.create(:name => "I Love Football", :email => "GoTeam@aol.com", :password => "SuperBowl")

      params = {
        :name => "I Love Football",
        :password => "BlahBlah"
      }
      post '/login', params
      expect(last_response.location).to include("/login")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")

      params = {
        :name => "FantasyWinner",
        :password => "SuperBowl"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end
  end

  describe 'user index page' do
    it 'shows all a single users teams' do
      user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
      team1 = Team.create(:name => "First Team", :user_id => user.id)
      team2 = Team.create(:name => "Second Team", :user_id => user.id)
      params = {
        :name => "FantasyWinner",
        :password => "SuperBowl"
      }
      post '/login', params

      get "/users/#{user.slug}"

      expect(last_response.body).to include("First Team")
      expect(last_response.body).to include("Second Team")
    end
  end

end
