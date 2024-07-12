class ApplicationController < ActionController::API

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:create_admin]

  def create_admin

      if current_user && current_user.admin?
        @admin_user = User.new(admin_user_params)

        puts "Current user: #{current_user.inspect}"
        puts "Current user role: #{current_user.role}"
        puts "Built resource: #{new_user.inspect}"

        if @admin_user.save

          render json: @admin_user, status: :created
        else
          puts "Errors occurred during resource creation: #{new_user.errors.full_messages}"
          render json: {
            errors: @admin_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        puts "Unauthorized access"
        render json: { error: "Unauthorized" }, status: :unauthorized
      end

  end

  private

  def authorize_admin
    unless current_user && current_user.admin?
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end

  def admin_user_params
    if @admin_user.role == 'admin'
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :role)
    end
  end

  def current_user
    @current_user ||= super
  end
end
