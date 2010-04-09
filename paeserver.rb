# Load essential libraries

require 'rubygems' 
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'haml'
require 'sass'

# Have DataMapper create a sqlite db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/paeserver.db")

# Tell haml we want html5
set :haml, { :format => :html5 }

# Define Pae

class Pae
  
  include DataMapper::Resource
  
  property :id,             Serial
  property :title,          String
  property :date,           Date

  has n, :authors
  has n, :advisors
  has n, :clients
end  

# Define Author

class Author

 include DataMapper::Resource
  
  property :huid,           Integer, :key => true, :length => 8 # HUID is a natural key, 8 digits long
  property :lname,          String
  property :mname,          String
  property :fname,          String
  
  belongs_to :pae

end

class Advisor

 include DataMapper::Resource
  
  property :id,             Serial
  property :advisor_lname,          String
  property :advisor_mname,          String
  property :advisor_fname,          String
  
  belongs_to :pae

end

class Client

 include DataMapper::Resource

  property :id,             Serial  
  property :org_name,       String
  property :mname,          String
  property :fname,          String
  
  belongs_to :pae
  has n, :contacts

end

class Contact
  include DataMapper::Resource
  
  property :id,             Serial
  property :org_name,       String
  property :mname,          String
  property :fname,          String
  
  belongs_to :pae
  has n, :contacts

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
  haml :new
end

# Create new Pae with params. If Pae is saved, also create and save Author. If successful, show the new record.

post '/create' do
  @pae = Pae.new(
    :title  => params["title"],
    :date   => params["date"]
  )
  if @pae.save
    @author = Author.new(
      :huid   => params["huid"],
      :lname  => params["lname"],
      :fname  => params["fname"],
      :pae_id => @pae.id
      )
    if @author.save
      redirect("/show/#{@pae.id}")
    end
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