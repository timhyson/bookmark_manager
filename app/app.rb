require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
  set :views, proc {File.join(root,'..','/app/views')}

get '/' do
  erb :index
end

 get '/links' do
   @links = Link.all
   erb :'links/index'
 end

 get '/links/new' do
   erb :'links/new_link'
 end

post '/links' do
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

 get '/tags/:name' do
   tag = Tag.first(name: params[:name])
   @links = tag ? tag.links : []
   erb :'links/index'
 end

 get '/users/new' do
   erb :'users/new'
 end

post '/users' do
  User.create(email: params[:email],
              password: params[:password])
  redirect to('/links')
end

# start the server if ruby file executed directly
run! if app_file == BookmarkManager
end
