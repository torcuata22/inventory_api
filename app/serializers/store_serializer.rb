class StoreSerializer < ActiveModel::Serializer
  attributes :id, :store_name, :store_address, :store_type, :manager
  has_many :books
end
