class NotifyUser

    class << self
      attr_defaultable :sms, -> {
        # set up Twilio client here
      }
    end

    attr_defaultable :sms_user, -> { '+17024260164' }
    attr_defaultable :sms_out, -> { ENV["SMS_OUT"] }

    def initialize(message)
      @from = sms_out;
      @to = sms_user;
      @message = message
    end

    def call
      NotifyUser.sms.send(from, to, message)  
    end

    attr_reader :from, :to, :message

end