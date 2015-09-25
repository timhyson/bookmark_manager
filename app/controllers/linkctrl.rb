# require_relative '../data_mapper_setup'

module Sinatra
  module BookmarkManager
    module App
      module Controllers
        module Linkctrl

          def self.registered(app)
            show_links = lambda do
              @links = Link.all
              erb :'links/index'
            end

            new_link = lambda do
              erb :'links/new_link'
              redirect to('/links')
            end

            create_link = lambda do
              link = Link.new(url: params[:url],    # 1. Create a link
                             title: params[:title],
                             tag: params[:tags])
              params[:tags] == "" ? params[:tags] = "no tags" : params[:tags]
              tags_array = params[:tags].split(" ")
              tags_array.each do |word|
                tag = Tag.create(name: word)        # 2. Create a tag for the link
                link.tags << tag                    # 3. Adding the tag to the link's DataMapper collection
                link.save
              end                                   # 4. Saving the link
              redirect to('/links')
            end

            delete_link = lambda do
              session[:user_id] = nil
              flash.next[:notice] = :goodbye!
              redirect to('/sessions/new')
            end

            show_tags = lambda do
              tag = Tag.first(name: params[:name])
              @links = tag ? tag.links : []
              erb :'links/index'
            end

            app.get '/links', &show_links
            app.get '/', &new_link
            app.get '/links/new', &new_link
            app.post '/links', &create_link
            app.delete '/links', &delete_link
            app.get '/tags/:name', &show_tags

          end

        end
      end
    end
  end
end
