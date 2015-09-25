require 'sinatra/base'
require 'sinatra/partial'

require_relative 'helpers'
require './app/controllers/linkctrl'
require './app/controllers/sessionctrl'
require './app/controllers/userctrl'
require_relative 'data_mapper_setup'
# require_relative 'models/link'
# require_relative 'models/tag'
# require_relative 'models/user'

class BookmarkManager < Sinatra::Base

  set :partial_template_engine, :erb
  set :session_secret, 'super secret'
  set :views, proc {File.join(root,'..','/app/views')}

  enable :sessions

  include Helpers

  use Rack::MethodOverride

  register Sinatra::Flash
  register Sinatra::Partial
  register Sinatra::BookmarkManager::App::Controllers::Linkctrl
  register Sinatra::BookmarkManager::App::Controllers::Sessionctrl
  register Sinatra::BookmarkManager::App::Controllers::Userctrl

  # start the server if ruby file executed directly
  run! if app_file == BookmarkManager

end
