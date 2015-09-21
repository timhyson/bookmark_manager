require 'sinatra/base'

class BookmarkManager < Sinatra::Base

 get '/links' do
   @links = Link.all
   erb :'links/index'
 end

 get '/links/new' do
   erb :'links/new'
 end

 post '/links' do
   Link.create(url: params[:url], title: params[:title])
   redirect to('/links')
 end

# start the server if ruby file executed directly
run! if app_file == BookmarkManager
end
