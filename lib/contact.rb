class Contact
  include DataMapper::Resource

  property :id,             Serial
  property :lname,          String
  property :fname,          String
  property :position,       String

  belongs_to :client

end
