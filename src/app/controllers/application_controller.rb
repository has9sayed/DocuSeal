class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_auth_token
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def not_found
    respond_to do |format|
      format.html { render file: Rails.public_path.join('404.html'), status: :not_found }
      format.json { render json: { error: 'Resource not found' }, status: :not_found }
    end
  end

  def invalid_auth_token
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Your session has expired. Please try again.' }
      format.json { render json: { error: 'Invalid authenticity token' }, status: :unprocessable_entity }
    end
  end

  def unprocessable_entity(exception)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: exception.record.errors.full_messages.join(', ') }
      format.json { render json: { errors: exception.record.errors }, status: :unprocessable_entity }
    end
  end
end 