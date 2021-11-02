class HomeController < ApplicationController
  before_action :authenticate!, only: :dashboard

  def index
    redirect_to dashboard_path if signed_in?
  end

  def dashboard
    @pagy, @messages = pagy(current_user.messages.trapped.order(sent_at: :DESC))
  end
end
