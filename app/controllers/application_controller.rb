class ApplicationController < ActionController::Base

  before_action :authenticate_user!,except: [:top, :index, :show]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :info])
  end

  def after_sign_in_path_for(resource)
    items_path
  end
    
end
