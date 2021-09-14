class HomeController < ApplicationController
  before_action :authenticate!, only: :dashboard

  def index
    redirect_to dashboard_path if signed_in?
  end
end
