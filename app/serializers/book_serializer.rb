class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :isbn, :description, :publication_details
  belongs_to :store
end
