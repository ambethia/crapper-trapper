class SendersController < ApplicationController
  def index
    @senders = current_user.senders
  end

  def create
    @sender = current_user.senders.create(sender_params)
  end

  def destroy
    @sender = current_user.senders.find(params[:id])
    @sender.destroy!
  end

  private

  def sender_params
    params.require(:sender).permit(:address, :list)
  end
end
