class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :dump_env

  protected

  def dump_env
    p "====="
    p request.base_url
    p request.headers['origin']
  end

  def not_authenticated
    redirect_to welcome_path
  end
end
