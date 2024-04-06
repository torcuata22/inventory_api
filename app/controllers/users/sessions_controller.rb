# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond to :json

end
