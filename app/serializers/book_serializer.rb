class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :isbn, :description, :publication_details
  has_many :stores
end
