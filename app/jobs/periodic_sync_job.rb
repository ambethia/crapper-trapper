class PeriodicSyncJob < ActiveJob::Base
  def perform(user)
    service = GmailService.new(user)
    service.scan_inbox
    service.process_pending_messages
  end
end
