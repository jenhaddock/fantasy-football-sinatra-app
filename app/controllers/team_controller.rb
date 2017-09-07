class TeamController < ApplicationController
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/teams/:slug' do
    if Helpers.is_logged_in?(session)
      @team = Team.find_by_slug(params["slug"])
      erb :'teams/show'
    else
      erb :homepage
    end
  end

end
