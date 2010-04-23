class Client

 include DataMapper::Resource

  property :id,             Serial
  property :org_name,       String

  belongs_to :pae
  has n, :contacts

end
