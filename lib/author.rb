class Author

 include DataMapper::Resource

# HUID is a natural key
  property :huid,           Integer, :key => true
  property :lname,          String
  property :fname,          String

  belongs_to :pae

end

