# ensure that the app runs in development mode by default
ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'



class BookmarkManager < Sinatra::Base

  # within the body of the Sinatra class
  enable :sessions
  set :session_secret, 'super secret'

  get '/links' do

# This uses DataMapper's .all method to fetch all
    # data pertaining to this class from the database
    @links = Link.all
    erb :'links/index'
  end

	get '/links/new' do
  	erb :'links/new'
	end
  
  # post '/links' do
  #   link = Link.new(url: params[:url],     # 1. Create a link
  #               title: params[:title])
  #   tag  = Tag.first_or_create(name: params[:tags])  # 2. Create a tag for the link
  #   link.tags << tag                       # 3. Adding the tag to the link's DataMapper collection.
  #   link.save                              # 4. Saving the link.
  #   redirect to('/links')
  # end
	
  # adjust the controller post '/links' route to handle multiple *space delimited* tags
  post '/links' do
   link = Link.create(url: params[:url], title: params[:title])

   params[:tags].split.each do |tag|
     link.tags << Tag.create(name: tag)
   end

   link.save
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

# save the user id in the session after it's created within app.rb
  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect to('/links')
  end
# helper method current_user, that returns an instance of User for the currently logged-in user
  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  # post '/users' do
  #   User.create(email: params[:email], password: params[:password])
  #   redirect to('/links')
  # end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
