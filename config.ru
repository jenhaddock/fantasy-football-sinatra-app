require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

require 'sinatra'

require_relative 'app/controllers/user_controller'
require_relative 'app/controllers/team_controller'

use Rack::MethodOverride
run ApplicationController
use UsersController
use TeamController
