require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  use Rack::MethodOverride
  register Sinatra::Flash
  set :session_secret, 'super secret'
  set :views, proc {File.join(root,'..','/app/views')}

get '/' do
  redirect to('/links')
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

delete '/links' do
  session[:user_id] = nil
  flash.next[:notice] = :goodbye!
  redirect to('/sessions/new')
end

get '/tags/:name' do
  tag = Tag.first(name: params[:name])
  @links = tag ? tag.links : []
  erb :'links/index'
end

get '/users/new' do
  @user = User.new
  erb :'users/new'
end

post '/users' do
  # we just initialize the object
  # without saving it. It may be invalid
  @user = User.new(email: params[:email],
                   password: params[:password],
                   password_confirmation: params[:password_confirmation])
  if @user.save # save returns true/false depending on whether the model is successfully saved to the database.
    session[:user_id] = @user.id
    redirect to('/links')
    # if it's not valid,
    # we'll render the sign up form again
  else
    flash.now[:errors] = @user.errors
    erb :'users/new'
  end
end

post '/sessions' do
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    redirect to('/links')
  else
    flash.now[:errors] = ['The email or password is incorrect']
    erb :'sessions/new'
  end
end

get '/sessions/new' do
  erb :'sessions/new'
end

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id])
  end
end

# start the server if ruby file executed directly
run! if app_file == BookmarkManager
end
