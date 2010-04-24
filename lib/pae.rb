class Pae

  include DataMapper::Resource

  property :id,             Serial
  property :title,          String, :length => 255
  property :date,           Date
  property :classified,     Boolean, :default => false
  property :url,            String, :length => 255

  has n, :authors
  has n, :advisors
  has n, :clients
  has n, :areas, :through => Resource 
end

