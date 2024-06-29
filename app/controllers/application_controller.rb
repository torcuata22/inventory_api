class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:create_admin, :create_manager, :create_employee]
  before_action :authorize_manager, only: [:create_manager, :create_employee]
  before_action :authorize_employee, only: [:create_employee]

  def create_admin
    @admin_user = User.new(admin_user_params)

    if @admin_user.save
      render json: @admin_user, status: :created
    else
      render json: { errors: @admin_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_manager
    @manager_user = User.new(manager_user_params)

    if @manager_user.save
      render json: @manager_user, status: :created
    else
      render json: { errors: @manager_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_employee
    @employee_user = User.new(employee_user_params)

    if @employee_user.save
      render json: @employee_user, status: :created
    else
      render json: { errors: @employee_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def authorize_admin
    render_unauthorized unless current_user.admin?
  end

  def authorize_manager
    render_unauthorized unless current_user.manager?
  end

  def authorize_employee
    render_unauthorized unless current_user.employee?
  end

  def admin_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :role)
  end

  def manager_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :role, :store_id)
  end

  def employee_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :role)
  end

  def current_user
    @current_user ||= super
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
