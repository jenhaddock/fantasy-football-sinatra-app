require 'spec_helper'

  describe TeamController do
    describe 'team show page' do
      it 'shows all a single teams players' do
        user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
        team = Team.create(:name => "First Team", :user_id => user.id)
        player1 = Player.create(:name => "Awesome RB", :position => "RB", :pro_team => "Hurricanes", :team_id => team.id)
        player2 = Player.create(:name => "Okay QB", :position => "QB", :pro_team => "Dolphins", :team_id => team.id)
        player3 = Player.create(:name => "Horrible DE", :position => "DE", :pro_team => "Detroit", :team_id => team.id)
        params = {
          :name => "FantasyWinner",
          :password => "SuperBowl"
        }
        post '/login', params

        get "/teams/#{team.slug}"

        expect(last_response.body).to include("Awesome RB")
        expect(last_response.body).to include("Okay QB")
        expect(last_response.body).to include("Horrible DE")
      end

      context 'logged out' do
        it 'does not let a user view the team info if not logged in' do
          get '/logout'

          get "/teams/first-team"
          expect(last_response.body).to include("Welcome")
        end
      end
    end
end
