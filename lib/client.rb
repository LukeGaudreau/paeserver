class Client

 include DataMapper::Resource

  property :id,             Serial
  property :org_name,       String, :length => 255
  property :lname,          String
  property :fname,          String
  property :position,       String
  
  belongs_to :pae

end
