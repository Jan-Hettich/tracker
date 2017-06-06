class NotifyUser

    class << self
      attr_defaultable :sms, -> {
        Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']).messages
      }
    end

    attr_defaultable :twilio_phone_number, -> { ENV['TWILIO_PHONE_NUMBER'] }
    attr_defaultable :user_phone_number, -> { ENV['DEFAULT_USER_PHONE_NUMBER'] }

    def initialize(message)
      @message = message
    end

    def call
      NotifyUser.sms.create(from: twilio_phone_number, to: user_phone_number, body: message)
    end

    attr_reader :message

end
