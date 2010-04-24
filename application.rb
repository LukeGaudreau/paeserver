# This application is written using the Sinatra framework (http://sinatrarb.com)
# (c) Luke Gaudreau 2010
# LIS469

# Load essential libraries

require 'rubygems'
require 'sinatra'
require 'datamapper'
require 'haml'
require 'sass'
require 'builder'

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

get '/show/xml/:id' do|id|
  headers "Content-Type" => "application/xml; charset=utf-8"
  @pae = Pae.get(params[:id])
  @title = @pae.title
  if @pae
    builder :show
  else
    redirect('list')  
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
  @pae = Pae.new(params[:pae])
  if @pae.save
    @authors = params["author"]
    @authors.each do |p|
      @author = @pae.authors.new(
        :fname => p["fname"],
        :lname => p["lname"],
        :huid => p["huid"],
        :pae_id => @pae.id
      )
      @author.save
    end
    @advisors = params["advisor"]
    @advisors.each do |p|
      @advisor = @pae.advisors.new(
        :fname => p["fname"],
        :lname => p["lname"],
        :pae_id => @pae.id
      )
      @advisor.save
    end
    @clients = params["client"]
    @clients.each do |p|
      @client = @pae.clients.new(
        :org_name => p["org_name"],
        :lname => p["lname"],
        :fname => p["fname"],
        :position => p["position"],
        :pae_id => @pae.id
      )
      @client.save
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

