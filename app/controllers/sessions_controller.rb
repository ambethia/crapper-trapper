class SessionsController < ApplicationController
  def create
    @user = User.from_auth_hash(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      SetupLabelsJob.perform_later(@user)
    end
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
