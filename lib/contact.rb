class Contact
  include DataMapper::Resource

  property :id,             Serial
  property :org_name,       String
  property :mname,          String
  property :fname,          String

  belongs_to :pae
  has n, :contacts

end
