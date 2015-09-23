class Link
  include DataMapper::Resource

  property :id,    Serial
  property :title, String
  property :url,   String
  property :tag,   String

  has n, :tags, through: Resource
end
