class TeamController < ApplicationController
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/teams/new' do
    if Helpers.is_logged_in?(session)
      erb :'teams/new'
    else
      erb :'users/login'
    end
  end

  get '/teams/:slug' do
    if Helpers.is_logged_in?(session)
      @team = Team.find_by_slug(params["slug"])
      erb :'teams/show'
    else
      erb :homepage
    end
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

  post '/teams' do
    if Team.find_by(:name => params[:name])
      @team = Team.find_by(:name => params[:name])
      flash[:message] = "Team already exists."
      redirect to "/teams/#{@team.slug}/edit"
    end
    @team = Team.create(:name => params[:name], :user_id => session["user_id"])
    params["team"]["player_ids"].each do |player|
      @player = Player.find_by(:id => player.to_i )
      @team.players << @player
    end
    @team.save
    redirect to "/teams/#{@team.slug}"
  end

  patch '/teams/:id' do
    @team = Team.find(params[:id])
    params["team"]["player_ids"].each do |player|
      @player = Player.find_by(:id => player.to_i )
      @team.players << @player
    end
    @team.save
    redirect to "/teams/#{@team.slug}"
  end
end
