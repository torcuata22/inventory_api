class Users::SessionsController < Devise::SessionsController
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  def new
    puts "Params received: #{params.inspect}"
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      sign_in user
      render json: {
        user: user.as_json(only: [:name, :avatar]),
        token: user.authentication_token
      }, status: :ok

    else
      puts "User not found or invalid password"
      render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      sign_out current_user
      render json: {message: 'User logged out successfulle'}, status: :ok
    else
      render json: {message: 'No user logged in'}, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
