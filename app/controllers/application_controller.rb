class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery prepend: true 

  protected

  def not_authenticated
    redirect_to welcome_path
  end
end
