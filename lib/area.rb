class Area

  include DataMapper::Resource

  # a string, but a natural key too -- these are course number abbreviations
  property :slug,           String, :key => true
  property :title,          String
  
  has n, :paes, :through => Resource

end
  
