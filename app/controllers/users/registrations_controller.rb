class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :json


  def create
    if current_user && current_user.role == 'admin'
      new_user = User.new(new_user_params)

      puts "Current user: #{current_user.inspect}"
      puts "Current user role: #{current_user.role}"
      puts "Built resource: #{new_user.inspect}"

      if new_user.save
        puts "Resource saved successfully"
        render json: new_user, status: :created
      else
        puts "Errors occurred during resource creation: #{new_user.errors.full_messages}"
        render json: {
          errors: new_user.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      puts "Unauthorized access"
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end



  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar)
  end

  def new_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :role)
  end


  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
