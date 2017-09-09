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

    describe 'new action' do
        context 'logged in' do
          it 'lets user view new team form if logged in' do
            user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")

            visit '/login'

            fill_in(:name, :with => "FantasyWinner")
            fill_in(:password, :with => "SuperBowl")
            click_button 'submit'
            visit '/teams/new'
            expect(page.status_code).to eq(200)
          end

          it 'lets user create a team if they are logged in' do
            user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
            visit '/login'

            fill_in(:name, :with => "FantasyWinner")
            fill_in(:password, :with => "SuperBowl")
            click_button 'submit'

            visit '/teams/new'
            fill_in(:name, :with => "Perfect Team")
            click_button 'Create'

            team = Team.find_by(:name => "Perfect Team")
            player1 = Player.create(:name => "Awesome RB", :position => "RB", :pro_team => "Hurricanes", :team_id => team.id)
            player2 = Player.create(:name => "Perfect QB", :position => "QB", :pro_team => "Dolphins", :team_id => team.id)
            player3 = Player.create(:name => "Outstanding DE", :position => "DE", :pro_team => "Detroit", :team_id => team.id)

            user = User.find_by(:name => "FantasyWinner")
            expect(team).to be_instance_of(Team)
            expect(team.user_id).to eq(user.id)
          end

          it 'does not let a user edit another users team' do
            user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
            user2 = User.create(:name => "I Love Football", :email => "FootballIsLife@aol.com", :password => "SuperBowl")

            visit '/login'

            fill_in(:name, :with => "FantasyWinner")
            fill_in(:password, :with => "SuperBowl")
            click_button 'submit'

            visit '/teams/new'

            fill_in(:name, :with => "Perfect Team")
            click_button 'Create'

            team = Team.find_by(:name => "Perfect Team")
            player1 = Player.create(:name => "Awesome RB", :position => "RB", :pro_team => "Hurricanes", :team_id => team.id)
            player2 = Player.create(:name => "Perfect QB", :position => "QB", :pro_team => "Dolphins", :team_id => team.id)
            player3 = Player.create(:name => "Outstanding DE", :position => "DE", :pro_team => "Detroit", :team_id => team.id)

            user = User.find_by(:id=> user.id)
            user2 = User.find_by(:id => user2.id)
            expect(team).to be_instance_of(Team)
            expect(team.user_id).to eq(user.id)
            expect(team.user_id).not_to eq(user2.id)
          end
        end
      end

    describe 'edit action' do
      context "logged in" do
        it 'lets a user view team edit form if they are logged in' do
          user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
          team = Team.create(:name => "Best Team", :user_id => user.id)
          visit '/login'

          fill_in(:name, :with => "FantasyWinner")
          fill_in(:password, :with => "SuperBowl")
          click_button 'submit'
          visit '/teams/best-team/edit'
          expect(page.status_code).to eq(200)
          expect(page.body).to include(team.name)
        end

        it 'does not let a user edit a team they did not create' do
          user1 = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
          team1 = Team.create(:name => "Best Team", :user_id => user1.id)

          user2 = User.create(:name => "I Love Football", :email => "FootballIsLife@aol.com", :password => "SuperBowl")
          team2 = Team.create(:name => "New Team", :user_id => user2.id)

          visit '/login'

          fill_in(:name, :with => "FantasyWinner")
          fill_in(:password, :with => "SuperBowl")
          click_button 'submit'
          session = {}
          session[:user_id] = user1.id
          visit "/teams/new-team/edit"
          expect(page.current_path).to include('/edit')
        end

        it 'lets a user edit their own team if they are logged in' do
          user = User.create(:name => "FantasyWinner", :email => "GoTeam@aol.com", :password => "SuperBowl")
          team = Team.create(:name => "Best Team", :user_id => 1)
          visit '/login'

          fill_in(:name, :with => "FantasyWinner")
          fill_in(:password, :with => "SuperBowl")
          click_button 'submit'
          visit '/teams/best-team/edit'

          player1 = Player.create(:name => "Awesome RB", :position => "RB", :pro_team => "Hurricanes", :team_id => 1)

          click_button 'Save'
          expect(Team.find_by(:name => "Best Team")).to be_instance_of(Team)
          expect(Team.find_by(:name => "Best Team").players).to include(player1)
        end
      end

      context "logged out" do
        it 'does not load let user view team edit form if not logged in' do
          get '/teams/new-team/edit'
          expect(last_response.location).to include("/login")
        end
      end
    end
end
