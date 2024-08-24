class Users::SessionsController < Devise::SessionsController

  respond_to :json

  private

  def respond_with(resource, options={})
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                  Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    render json: {
      status: { code: 200, message: "Login successfull",
      data: current_user }
    }, status: :ok
  end

  def respond_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
        render json: {
          status: 200,
          message: "Successfully logged out"
        }, status: :ok
    else
        render json: {
          status: 401,
          message: "There is no active session for this user"
        }, status: :unauthorized
    end
  end
end
