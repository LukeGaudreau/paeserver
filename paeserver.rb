# This application is written using the Sinatra framework (http://sinatrarb.com)
# (c) Luke Gaudreau 2010
# LIS469

# Load essential libraries

require 'rubygems'
require 'sinatra'
require 'datamapper'
require 'haml'
require 'sass'

# load local libraries 

Dir.glob('lib/*.rb') do |lib|
    require lib
end

configure do
  # Have DataMapper create a sqlite db
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/paeserver.db")

  # Tell haml we want html5
  set :haml, { :format => :html5 }
end

# Create  or upgrade all tables at once, like magic :)
DataMapper.auto_upgrade!

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

# Define routes

get '/' do
  @title = "Welcome to the PAE Server"
  haml :index
end

get '/show/:id' do |id|
  @pae = Pae.get(params[:id])
  if @pae
    haml :show
  else
    redirect('/list')
  end
end

get '/list' do
  @title = "List PAEs"
  @paes = Pae.all
  haml :list
end

get '/new' do
  @title = "Add a new Policy Analysis Exercise"
  haml :new, {:layout => :form}
end

# Create new Pae with params. If Pae is saved, also create and save the rest. If successful, show the new record.

post '/create' do
  @pae = Pae.new(params[:data][:pae])
  if @pae.save
    @author = Author.new(
      :lname => params["data"]["author"]["lname_1"],
      :fname => params["data"]["author"]["fname_1"],
      :huid  => params["data"]["author"]["huid_1"],
      :pae_id => @pae.id
    )
    @author.save
    @advisor = Advisor.new(
      :lname => params["data"]["advisor"]["lname_1"],
      :fname => params["data"]["advisor"]["fname_1"],
      :pae_id => @pae.id
    )
    @advisor.save
    @client = Client.new(
      :org_name => params["data"]["client"]["org_name_1"],
      :pae_id => @pae.id
    )
    if @client.save
      @contact = Contact.new(
        :lname => params["data"]["contact"]["lname_1"],
        :fname => params["data"]["contact"]["fname_1"],
        :position => params["data"]["contact"]["position_1"],
        :client_id => @client.id
      )
      @contact.save
    end
    redirect("/show/#{@pae.id}")
  else
    redirect("/list")
  end
end

get '/delete/:id' do
end

# Intercept css request and pass to sass

get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

