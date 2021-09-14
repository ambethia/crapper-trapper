class SessionsController < ApplicationController
  def create
    @user = User.from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = @user.id if @user
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
