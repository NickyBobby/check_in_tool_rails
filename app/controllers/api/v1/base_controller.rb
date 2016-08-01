class Api::V1::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  after_action :verify_authorized

  protect_from_forgery with: :null_session
end
