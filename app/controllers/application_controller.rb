class ApplicationController < ActionController::API

  before_action :authenticate_user!

  private

  def current_user
    @current_user ||= super
  end
end
