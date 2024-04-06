class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :avatar

  attribute :avatar_url do |object|
    object.avatar.url
  end
end


#call using the following command:
#user = User.find(1)
#UserSerializer.new(#user).serializable_hash[:data][:attributes]
#serialized_user = UserSerializer.new(user).serializable_hash[:data][:attributes]
