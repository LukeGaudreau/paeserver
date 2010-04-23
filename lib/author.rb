class Author

 include DataMapper::Resource

# HUID is a natural key, 8 digits long
  property :huid,           Integer, :key => true, :length => 8
  property :lname,          String
  property :fname,          String

  belongs_to :pae

end

