require 'sinatra/base'

# ensure that the app runs in development mode by default
ENV["RACK_ENV"] ||= "development"

# We're gonna need our Link model
require_relative 'models/link'

class BookmarkManager < Sinatra::Base
  get '/links' do

# This uses DataMapper's .all method to fetch all
    # data pertaining to this class from the database
    @links = Link.all
    erb :'links/index'
  end

	get '/links/new' do
  	erb :'links/new'
	end
  
  post '/links' do
  	Link.create(url: params[:url], title: params[:title])
  	redirect '/links'
	end
	
  # start the server if ruby file executed directly
  run! if app_file == $0
end
