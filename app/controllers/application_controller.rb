class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :homepage
  end
end
