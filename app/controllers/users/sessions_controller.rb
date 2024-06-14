class Users::SessionsController < Devise::SessionsController

  respond_to :json
  before_action :configure_sign_in_params, only: [:create]

  def create
    puts "Params received: #{params.inspect}"
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      sign_in user
      render json: {
        user: user.as_json(only: [:name, :avatar]),
        token: user.authentication_token
      }, status: :ok
      puts "You are signed in as #{current_user}"
    else
      puts "User not found or invalid password"
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end


  def destroy
    if current_user
      sign_out current_user
      head :no_content
      puts "You have been logged out"
    else
      render json: {message: 'No user logged in'}, status: :unprocessable_entity
    end
  end



  private

  def session_params
    params.permit(:email, :password)
  end

  def respond_to_on_destroy
    head :no_content
  end

end
