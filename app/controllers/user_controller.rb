class UsersController < ApplicationController
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      erb :'users/index'
    else
      erb :'users/create_user'
    end
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      erb :'users/index'
    else
      erb :'users/login'
    end
  end

  post '/signup' do
    if params[:username] != "" && params[:email] != "" && params[:password] != ""
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      erb :'users/index'
    else
      redirect to '/signup'
    end
  end

end
