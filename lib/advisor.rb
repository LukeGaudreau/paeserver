class Advisor

 include DataMapper::Resource

  property :id,             Serial
  property :lname,          String
  property :fname,          String

  belongs_to :pae

end
