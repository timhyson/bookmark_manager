# require_relative '../data_mapper_setup'

module Sinatra
  module BookmarkManager
    module App
      module Controllers
        module Userctrl

          def self.registered(app)
            new_user = lambda do
              @user = User.new
              erb :'users/new'
            end

            create_user = lambda do
              @user = User.create(email: params[:email],
                               password: params[:password],
                               password_confirmation: params[:password_confirmation])
              if @user.save
                session[:user_id] = @user.id
                redirect to('/links')
              else
                flash.now[:errors] = @user.errors
                erb :'users/new'
              end
            end

            app.get  '/users/new', &new_user
            app.post '/users', &create_user
          end

        end
      end
    end
  end
end
