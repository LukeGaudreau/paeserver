class Advisor

 include DataMapper::Resource

  property :id,             Serial
  property :lname,          String
  property :mname,          String
  property :fname,          String

  belongs_to :paeX

end
