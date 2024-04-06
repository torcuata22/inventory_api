class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :avatar, :created_at, :updated_at

end
