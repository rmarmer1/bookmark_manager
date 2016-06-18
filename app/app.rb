ENV['RACK_ENV'] ||= "development"
require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'


class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    erb(:index) # index.erb displays user's bookmarks - if signed-in
                # else user is redirected to sessions/new
  end

  post '/' do
    @user = User.create(params)
    # name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation], email: params[:email]
    if @user.id
      session[:user_id] = @user.id
      @user.save
      redirect '/links'
    else
      #flash.now[:notice] = current_user ? nil : 'Password and confirmation do not match'
      flash.now[:errors] = @user.errors.full_messages
      erb(:index)
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
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
  
  get '/links' do
  	@links = Link.all
  	erb(:'links/index')
  end

  get '/links/new' do
  	erb(:'links/new')
  end

  post '/links' do
  	link = Link.create(url: params[:url], title: params[:title])
    tags = params[:tags].split(", ").each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end

    link.save
  	redirect('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @name = params[:name]
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/links/signout'  do
    erb :'links/signout'
  end

  post '/signout' do
    @current_user = nil
    redirect 'links/signout'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == $0
end
