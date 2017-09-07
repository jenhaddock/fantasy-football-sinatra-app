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

    get '/teams/:slug/edit' do
      if Helpers.is_logged_in?(session)
        @team = Team.find_by_slug(params["slug"])
        if session[:user_id] == @team.user_id
          erb :'teams/edit'
        else
          erb :'users/index'
        end
      else
        redirect to '/login'
      end
    end

    post '/teams/:id' do
      @team = Team.find(params[:id])
      @team.save
      redirect to "teams/show"
    end
end
