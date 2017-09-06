class UsersController < ApplicationController
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/signup' do
    erb :'users/create_user'
  end

end
