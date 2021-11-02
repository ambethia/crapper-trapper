class SetupLabelsJob < ActiveJob::Base
  def perform(user)
    service = GmailService.new(user)
    service.setup_labels
  end
end
