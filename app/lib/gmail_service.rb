require 'google/apis/gmail_v1'

class GmailService
  MAIN_LABEL = 'CrapperTrapper'
  CRAP_LABEL = 'CrapperTrapper/CRAP'
  TRAP_LABEL = 'CrapperTrapper/TRAP'

  def initialize(user)
    @user = user
  end

  def service
    @service ||= begin
      client = Signet::OAuth2::Client.new(access_token: @user.current_access_token)
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      service
    end
  end

  def scan_inbox
    next_page = nil
    loop do
      response = service.list_user_messages('me', label_ids: ['INBOX'], page_token: next_page)
      response.messages.each do |message|
        import_message(message.id)
      end
      break unless (next_page = response.next_page_token)
    end
  end

  def import_message(message_id)
    return if Message.where(message_id: message_id).exists?

    message = service.get_user_message('me', message_id)
    sender = Mail::Address.new(message.payload.headers.find { |header| header.name == 'From' }.value)
    @user.messages.create!(
      message_id: message_id,
      snippet: message.snippet,
      subject: message.payload.headers.find { |header| header.name == 'Subject' }&.value,
      sender_address: sender.address,
      sender_domain: sender.domain,
      sender_name: sender.display_name,
      sent_at: Time.parse(message.payload.headers.find { |header| header.name == 'Date' }&.value)
    )
  end

  def process_pending_messages
    @user.messages.pending.each do |message|
      trap_or_crap(message)
    end
  end

  def trap_or_crap(message)
    is_blocked = Sender.blocked.where(address: message.sender_address).exists? ||
                 Sender.blocked.where(domain: message.sender_domain, is_for_domain: true).exists?

    if is_blocked
      service.modify_message(
        'me',
        message.message_id,
        {
          add_label_ids: [@user.crap_label],
          remove_label_ids: ['INBOX', @user.trap_label]
        }
      )
      message.crapped!
    else
      is_allowed = Sender.allowed.where(address: message.sender_address).exists? ||
                   Sender.allowed.where(domain: message.sender_domain, is_for_domain: true).exists?
      if is_allowed
        message.dismiss!
      else
        service.modify_message(
          'me',
          message.message_id,
          {
            add_label_ids: [@user.trap_label],
            remove_label_ids: ['INBOX', @user.crap_label]
          }
        )
        message.trapped!
      end
    end
  end

  def setup_labels
    main_label = nil
    crap_label = nil
    trap_label = nil

    existing_labels = @service.list_user_labels('me').labels
    existing_labels.each do |label|
      main_label = label if label.name == MAIN_LABEL
      crap_label = label if label.name == CRAP_LABEL
      trap_label = label if label.name == TRAP_LABEL
    end

    @service.create_user_label('me', { name: MAIN_LABEL }) unless main_label.present?

    if crap_label.present?
      @user.update(crap_label: crap_label.id) unless crap_label.id == @user.crap_label
    else
      crap_label = @service.create_user_label('me', { name: CRAP_LABEL })
      @user.update(crap_label: crap_label.id)
    end

    if trap_label.present?
      @user.update(trap_label: trap_label.id) unless trap_label.id == @user.trap_label
    else
      trap_label = @service.create_user_label('me', { name: TRAP_LABEL })
      @user.update(trap_label: trap_label.id)
    end
  end
end
