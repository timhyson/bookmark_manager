# require_relative '../data_mapper_setup'

module Sinatra
  module BookmarkManager
    module App
      module Controllers
        module Sessionctrl

          def self.registered(app)
            show_login = lambda do
              erb :'sessions/new'
            end

            receive_login = lambda do
              user = User.authenticate(params[:email], params[:password])
              if user
                session[:user_id] = user.id
                redirect to('/links')
              else
                flash.now[:errors] = ['The email or password is incorrect']
                erb :'sessions/new'
              end
            end

            app.get  '/', &show_login
            app.get  '/sessions/new', &show_login
            app.post '/sessions/new', &show_login
          end

        end
      end
    end
  end
end
