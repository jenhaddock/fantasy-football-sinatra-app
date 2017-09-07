class UsersController < ApplicationController
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end
#      use Rack::Flash

  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect to '/index'
    else
      erb :'users/create_user'
    end
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect to '/index'
    else
      erb :'users/login'
    end
  end

  get '/index' do
    if Helpers.is_logged_in?(session)
      @user = User.find_by(:id => session["user_id"])
      erb :'users/index'
    else
      erb :'users/login'
    end
  end

  get '/users/:slug' do
    if Helpers.is_logged_in?(session)
      @user = User.find_by_slug(params["slug"])
      erb :'users/index'
    else
      erb :homepage
    end
  end

  get '/logout' do
    if Helpers.is_logged_in?(session)
     session.clear
     redirect to '/login'
   else
     redirect to '/'
   end
  end

  post '/signup' do
    if User.find_by(:name => params[:name])
#      flash[:message] = "User already exists."
      redirect to '/login'
    end
    if params[:name] != "" && params[:email] != "" && params[:password] != ""
      @user = User.create(:name => params[:name], :password => params[:password])
      session[:user_id] = @user.id
      redirect to '/index'
    else
      redirect to '/signup'
    end
  end

  post '/login' do
    @user = User.find_by(:name => params[:name])
    if @user != nil && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/index'
    else
      redirect to '/login'
    end
  end

end
