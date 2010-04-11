class Pae

  include DataMapper::Resource

  property :id,             Serial
  property :title,          String
  property :date,           Date
  property :classified,     Boolean, :default => false

  has n, :authors
  has n, :advisors
  has n, :clients
end

