class NotifyUser

    class << self
      attr_defaultable :sms, -> {
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        @client.messages
      }
    end

    attr_defaultable :sms_user, -> { ENV['DEFAULT_USER_PHONE_NUMBER'] }
    attr_defaultable :twilio_number, -> { ENV['TWILIO_PHONE_NUMBER'] }

    def initialize(message)
      @from = twilio_number;
      @to = sms_user;
      @message = message
    end

    def call
      NotifyUser.sms.create(from: from, to: to, body: message)
    end

    attr_reader :from, :to, :message

end
