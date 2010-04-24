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
  @title = @pae.title
  if @pae
    haml :show
  else
    redirect('/list')
  end
end

get '/list' do
  @paes = Pae.all
  @title = "Listing " + @paes.count.to_s + " Policy Analysis Exercises."
  haml :list
end

get '/new' do
  @title = "Add a new Policy Analysis Exercise"
  @areas = Area.all
  haml :new, {:layout => :form}
end

# Create new Pae with params. If Pae is saved, also create and save the rest. If successful, show the new record.
post '/test' do
  @params.inspect
end
post '/create' do
  @pae = Pae.new(params[:data][:pae])
  if @pae.save
    @author = Author.new(
      :lname => params["data"]["author"]["0"]["lname"],
      :fname => params["data"]["author"]["0"]["fname"],
      :huid  => params["data"]["author"]["0"]["huid"],
      :pae_id => @pae.id
    )
    @author.save
    @advisor = Advisor.new(
      :lname => params["data"]["advisor"]["0"]["lname"],
      :fname => params["data"]["advisor"]["0"]["fname"],
      :pae_id => @pae.id
    )
    @advisor.save
    @client = Client.new(
      :org_name => params["data"]["client"]["0"]["org_name"],
      :pae_id => @pae.id
    )
    if @client.save
      @contact = Contact.new(
        :lname => params["data"]["contact"]["0"]["lname"],
        :fname => params["data"]["contact"]["0"]["fname"],
        :position => params["data"]["contact"]["0"]["position"],
        :client_id => @client.id
      )
      @contact.save
    end
    @areaP = params["data"]["paes"]["area_slug"]
    @areaP.each do |area,i|
      @area = @pae.area_paes.new(
        :area_slug => area,
        :pae_id => @pae.id
      )
      @area.save
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

