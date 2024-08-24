# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
#TODO: CHECK WHY IT'S NOT SAVING STORE_ID
  private
  def respond_with (resource, options={})
    if resource.persisted?
      render json: {
        statu: { code: 200, message: "Signed up sucessfully", data: resource }
      }, sataus: :ok

    else
      render json: {
        status: { message: "User could not be created",
        errors: resource.errors.full_messages }, status: :unprocessable_entity
      }
    end
  end
end
