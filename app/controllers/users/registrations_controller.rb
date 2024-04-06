class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?

    if resource.persisted?
      render json: {
        status: { code: 200, message: "Sign up successful" },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { code: 422, message: "User could not be created successfully", errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end
end
